class GitLog
  attr_reader :symbolic_from, :symbolic_to, :git_commits

  def initialize(symbolic_from, symbolic_to, git_commits)
    @symbolic_from = symbolic_from
    @symbolic_to   = symbolic_to
    @git_commits   = git_commits
  end

  def more_commits?
    @git_commits.size > 50
  end
end
