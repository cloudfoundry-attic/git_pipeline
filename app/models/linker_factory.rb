class LinkerFactory
  def linker_for_git_repo(git_repo)
    if git_repo.remote_url =~ /github\.com/
      GithubLinker.new(normalized_url(git_repo.remote_url))
    elsif git_repo.remote_url =~ /code\.google\.com/
      GoogleCodeLinker.new(normalized_url(git_repo.remote_url))
    elsif !git_repo.remote_url
      RickAstleyLinker.new
    else
      raise ArgumentError, "failed to build linker for url #{git_repo.remote_url.inspect}"
    end
  end

  private

  GIT_URL = %r{\Agit://(.+):(.+)(\.git)?\z}

  def normalized_url(repo_url)
    if repo_url =~ GIT_URL
      "https://#{$1}/#{$2}"
    else
      repo_url.gsub(".git", "")
    end
  end
end
