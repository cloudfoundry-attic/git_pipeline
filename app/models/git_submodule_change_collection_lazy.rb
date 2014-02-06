class GitSubmoduleChangeCollectionLazy
  include Enumerable

  alias_method :size, :count

  def initialize(git_repo, git_log)
    @git_repo = git_repo
    @git_log = git_log
  end

  def each(*args, &blk)
    compute_collection.each(*args, &blk)
  end

  private

  def compute_collection
    @compute_collection ||= begin
      grepo = Git.open(@git_repo.local_dir)
      @git_log.git_commits.map { |git_commit|
        gcommit = grepo.gcommit(git_commit.sha)
        submodule_changes_from_gcommit(gcommit)
      }.flatten
    end
  end

  # diff --git a/src/gorouter/src/github.com/cloudfoundry/gorouter b/src/gorouter/src/github.com/cloudfoundry/gorouter
  # index 8b43ef2..d025a78 160000
  # --- a/src/gorouter/src/github.com/cloudfoundry/gorouter
  # +++ b/src/gorouter/src/github.com/cloudfoundry/gorouter # <-- path
  # @@ -1 +1 @@
  # -Subproject commit 8b43ef21e31d1575ee581ba9f6b3b6a1d3d0178f # <-- src
  # +Subproject commit d025a7871d7cfbcb77baccb3133008146c67a85e # <-- dst
  GIT_SUBMODULE_CHANGE_TEXT = "Subproject commit".freeze

  def submodule_changes_from_gcommit(gcommit)
    gdiff = gcommit.diff_parent
    return [] unless gdiff.patch.include?(GIT_SUBMODULE_CHANGE_TEXT)

    gdiff.map { |gdiff_file|
      next unless gdiff_file.patch.include?(GIT_SUBMODULE_CHANGE_TEXT)

      submodule_git_repo = @git_repo.submodule_git_repo(gdiff_file.path)
      submodule_git_log  = GitLog.from_symbolic_range(
        submodule_git_repo, gdiff_file.dst, gdiff_file.src)

      GitSubmoduleChange.new(gdiff_file.path, submodule_git_repo, submodule_git_log)
    }.compact
  end
end
