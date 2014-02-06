class GitLog
  attr_reader :symbolic_from, :symbolic_to, :git_commits

  def self.from_symbolic_range(git_repo, symbolic_from, symbolic_to)
    fetcher     = GitCommitFetcher.new(git_repo, symbolic_from, symbolic_to)
    git_commits = GitCommitCollectionLazy.new(fetcher)
    new(symbolic_from, symbolic_to, git_commits)
  end

  def initialize(symbolic_from, symbolic_to, git_commits)
    @symbolic_from = symbolic_from
    @symbolic_to   = symbolic_to
    @git_commits   = git_commits
  end

  def git_commits_available?
    @git_commits.available?
  end

  def more_commits?
    @git_commits.size > 100
  end

  def +(operand)
    raise ArgumentError, "operand must be a #{self.class.name}" \
      unless operand.is_a?(self.class)

    # Should log continuity be enforced?
    #if (a = operand.symbolic_to) != (b = symbolic_from)
    #  raise ArgumentError,
    #    "operand's symbolic_to (#{a.inspect}) " +
    #    "must equal self's symbolic_from (#{b.inspect}) " +
    #    "to form a continious block of git commits;\n\n" +
    #    "self's commits: #{git_commits.to_a.inspect};\n\n" +
    #    "operands's commits: #{operand.git_commits.to_a.inspect}"
    #end

    all_git_commits = GitCommitCollectionSum.new(git_commits, operand.git_commits)
    self.class.new(operand.symbolic_from, symbolic_to, all_git_commits)
  end
end
