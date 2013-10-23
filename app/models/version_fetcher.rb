class VersionFetcher
  def initialize(git_repo, name_pattern)
    @git_repo = git_repo
    @name_pattern = name_pattern
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
    grepo = Git.open(@git_repo.local_dir)

    git_tags = grepo.tags.map do |gt|
      version = extract_version_from_name(gt.name)
      GitTag.new(gt.name, gt.sha, version)
    end

    git_tags.select(&:versioned?).sort_by(&:version)
  end

  def extract_version_from_name(name)
    if matched = name.match(@name_pattern)
      matched[:number]
    end
  end
end
