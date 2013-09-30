class GitCommitFetcher
  def initialize(git_repo, symbolic_from, symbolic_to)
    @git_repo      = git_repo
    @symbolic_from = symbolic_from
    @symbolic_to   = symbolic_to
  end

  def fetch
    grepo    = Git.open(@git_repo.local_dir)
    glog     = grepo.log(51)
    gcommits = glog.between(@symbolic_from, @symbolic_to)
    gcommits.map { |gc| GitCommit.new(gc.sha, gc.message, gc.author.name) }
  end
end
