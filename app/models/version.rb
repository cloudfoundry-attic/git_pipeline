class Version
  attr_reader :name, :git_log, :git_submodule_change_log

  def initialize(name, git_log, git_submodule_change_log)
    @name = name
    @git_log = git_log
    @git_submodule_change_log = git_submodule_change_log
  end

  def pending_changes?
    git_log.git_commits.any?
  end
end
