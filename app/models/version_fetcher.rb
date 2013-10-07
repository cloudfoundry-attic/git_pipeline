class VersionFetcher
  def initialize(git_repo)
    @git_repo = git_repo
  end

  def fetch(num)
    git_tags = fetched_git_tags
    git_tags.map.with_index { |git_tag, i|
      version_from_git_tags(git_tags[i-1], git_tag) if i > 0
    }.compact.reverse[0...num]
  end

  private

  def version_from_git_tags(git_tag_from, git_tag_to)
    git_log = GitLog.from_symbolic_range(
      @git_repo, git_tag_from.name, git_tag_to.name)
    Stage.new("Release #{git_tag_to.name}", git_log)
  end

  def fetched_git_tags
    grepo    = Git.open(@git_repo.local_dir)
    git_tags = grepo.tags.map { |gt| GitTag.new(gt.name, gt.sha) }
    git_tags.select(&:versioned?).sort_by(&:version)
  end
end
