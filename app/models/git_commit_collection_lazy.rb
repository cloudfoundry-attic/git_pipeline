class GitCommitCollectionLazy
  include Enumerable

  # wtf enumerable?
  alias_method :size, :count

  def initialize(git_commit_fetcher)
    @git_commit_fetcher = git_commit_fetcher
  end

  def each(*args, &blk)
    @commits ||= @git_commit_fetcher.fetch
    @commits.each(*args, &blk)
  end
end
