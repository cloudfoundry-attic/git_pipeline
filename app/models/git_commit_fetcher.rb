class GitCommitFetcher
  class FetchError < StandardError; end

  def initialize(git_repo, symbolic_from, symbolic_to)
    @git_repo      = git_repo
    @symbolic_from = symbolic_from
    @symbolic_to   = symbolic_to
  end

  def fetch
    # Might raise #<ArgumentError: path does not exist>
    # with backtrace set to the path it was trying to open
    grepo = Git.open(@git_repo.local_dir)

    glog = grepo.log(101)
    gcommits = glog.between(@symbolic_from, @symbolic_to)
    gcommits.map { |gc| GitCommit.new(gc.sha, gc.message, gc.author.name) }
  rescue Exception => e
    raise FetchError, e.inspect
  end
end
