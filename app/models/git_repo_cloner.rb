class GitRepoCloner
  def initialize
    @lock = Mutex.new
  end

  def clone(git_repo)
    @lock.synchronize do
      clone_without_lock(git_repo)
      git_repo.last_fetched_at = Time.now
    end
  end

  private

  def clone_without_lock(git_repo)
    dir = git_repo.local_dir
    url = git_repo.github_url

    if Dir.exist?(dir)
      Git.open(dir).fetch
    else
      FileUtils.rm_rf(dir)
      Git.clone(url, dir)
    end
  end
end
