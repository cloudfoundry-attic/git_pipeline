class GitCommitCollectionLazy
  class NotAvailableError < StandardError; end

  include Enumerable

  # wtf enumerable?
  alias_method :size, :count

  def initialize(git_commit_fetcher)
    @git_commit_fetcher = git_commit_fetcher
    @commits = nil
    @available = false
  end

  def available?
    fetch_commits
    @available
  end

  def each(*args, &blk)
    raise NotAvailableError, "commits are not available" unless available?
    @commits.each(*args, &blk)
  end

  private

  def fetch_commits
    @commits ||= @git_commit_fetcher.fetch
    @available = true
  rescue @git_commit_fetcher.class::FetchError
    @available = false
  end
end
