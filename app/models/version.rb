class Version
  attr_reader :name, :git_log

  def initialize(name, git_log)
    @name = name
    @git_log = git_log
  end

  def pending_changes?
    git_log.git_commits.any?
  end
end
