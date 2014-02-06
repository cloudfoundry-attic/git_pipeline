class GitRepoCloner
  class Error < RuntimeError; end

  FETCH_IS_OLD_AFTER_SECS = 120.seconds

  def initialize(logger)
    @fetch_times_by_path = {}
    @lock = Mutex.new
    @logger = logger
  end

  def clone(git_repo, opts={})
    avoid_fetch = !!opts[:avoid_fetch]
    force_fetch = !!opts[:force_fetch]
    @lock.synchronize do
      clone_or_fetch_without_lock(git_repo, avoid_fetch, force_fetch)
    end
  end

  private

  def clone_or_fetch_without_lock(git_repo, avoid_fetch, force_fetch)
    if Dir.exist?(git_repo.local_dir)
      if force_fetch
        fetch_now(git_repo)
      elsif !avoid_fetch
        fetch_if_old(git_repo)
      end
    else
      clone_now(git_repo)
    end

    git_repo.last_fetched_at = time_last_fetched(git_repo)

  rescue Git::GitExecuteError => e
    raise Error, e.inspect
  end

  def fetch_if_old(git_repo)
    curr_t = Time.now.to_i
    last_t = time_last_fetched(git_repo).to_i
    if (curr_t - last_t) > FETCH_IS_OLD_AFTER_SECS
      @logger.info("Fetched copy is old")
      fetch_now(git_repo)
    else
      @logger.info("Fetched copy is still fresh")
    end
  end

  def clone_now(git_repo)
    @logger.info("Running repo clone (recursive)")
    Git.clone(git_repo.remote_url, git_repo.local_dir, recursive: true)
    mark_as_fetched(git_repo)
  end

  def fetch_now(git_repo)
    grepo = Git.open(git_repo.local_dir)

    log_info_time("Running repo fetch")
    grepo.fetch

    log_info_time("Running repo submodule_update_recursive")
    grepo.submodule_update_recursive

    log_info_time("Done repo updating")
    mark_as_fetched(git_repo)
  end

  def time_last_fetched(git_repo)
    @fetch_times_by_path[git_repo.local_dir]
  end

  def mark_as_fetched(git_repo, t=Time.now)
    @fetch_times_by_path[git_repo.local_dir] = t
  end

  private

  # Injected logger might not have formatter that includes time
  def log_info_time(msg)
    @logger.info("#{Time.now} #{msg}")
  end
end
