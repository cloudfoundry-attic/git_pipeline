class GitRepo
  attr_reader :local_dir, :github_url

  attr_accessor :last_fetched_at

  def initialize(local_dir, github_url)
    @local_dir  = local_dir
    @github_url = github_url
  end
end
