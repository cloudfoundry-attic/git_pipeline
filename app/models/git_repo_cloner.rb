class GitRepoCloner
  class Error < RuntimeError; end

  def initialize(logger)
    @lock = Mutex.new
    @logger = logger
  end

  def clone(git_repo, opts={})
    avoid_fetch = !!opts[:avoid_fetch]
    @lock.synchronize do
      clone_without_lock(git_repo, avoid_fetch)
      git_repo.last_fetched_at = Time.now
    end
  end

  private

  def clone_without_lock(git_repo, avoid_fetch)
    dir = git_repo.local_dir
    url = git_repo.remote_url

    if Dir.exist?(dir)
      unless avoid_fetch
        grepo = Git.open(dir)
        log_info_time("Running repo fetch")
        grepo.fetch
        log_info_time("Running repo submodule_update_recursive")
        grepo.submodule_update_recursive
        log_info_time("Done repo updating")
      end
    else
      Git.clone(url, dir, recursive: true)
    end
  rescue Git::GitExecuteError => e
    raise Error, e.message
  end

  private

  # Injected logger might not have formatter that includes time
  def log_info_time(msg)
    @logger.info("#{Time.now} #{msg}")
  end
end
