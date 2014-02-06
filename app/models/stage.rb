class Stage
  attr_reader :name, :ci_url, :git_log

  def initialize(name, ci_url, git_log)
    @name = name
    @ci_url = ci_url
    @git_log = git_log
  end

  def has_ci_url?
    !!@ci_url
  end

  def pending_changes?
    git_log.git_commits.any?
  end
end
