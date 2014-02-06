class GitSubmoduleChangeLog
  attr_reader :symbolic_from, :symbolic_to, :git_submodule_changes

  def self.from_git_log(git_repo, git_log)
    git_submodule_changes = GitSubmoduleChangeCollectionLazy.new(git_repo, git_log)
    new(git_log.symbolic_from, git_log.symbolic_to, git_submodule_changes)
  end

  def initialize(symbolic_from, symbolic_to, git_submodule_changes)
    @symbolic_from = symbolic_from
    @symbolic_to   = symbolic_to
    @git_submodule_changes = git_submodule_changes
  end

  def aggregate_git_submodule_changes
    @aggregate_git_submodule_changes ||= build_aggregate_git_submodule_changes
  end

  private

  def build_aggregate_git_submodule_changes
    @git_submodule_changes
      .group_by(&:path)
      .map { |_, changes| changes.inject(:+) }
      .sort_by(&:path)
  end
end
