class PipelineFileLoader
  class LoadError < StandardError; end

  def initialize(file_path)
    @file_path = file_path
  end

  def load
    pipeline_hash = read_file

    git_repo = build_git_repo(pipeline_hash["git_repo"])

    stages = pipeline_hash["stages"].map do |stage_hash|
      git_log = build_git_log(stage_hash["git_log"], git_repo)
      stage   = build_stage(stage_hash, git_log)
    end

    versions = build_versions(pipeline_hash["versions"], git_repo)

    build_pipeline(pipeline_hash, git_repo, stages, versions)
  end

  private

  def read_file
    YAML.load_file(@file_path)
  rescue SystemCallError => e
    raise LoadError, e.message
  end

  def build_pipeline(hash, git_repo, stages, versions)
    id = File.basename(@file_path, ".yml")
    Pipeline.new(id, hash["name"], git_repo, stages, versions)
  end

  def build_git_repo(hash)
    GitRepo.new(hash["local_dir"], hash["github_url"])
  end

  def build_stage(hash, git_log)
    Stage.new(hash["name"], git_log)
  end

  def build_git_log(hash, git_repo)
    GitLog.from_symbolic_range(git_repo, hash["from"], hash["to"])
  end

  def build_versions(hash, git_repo)
    name_pattern    = Regexp.new(hash["name_pattern"])
    version_fetcher = VersionFetcher.new(git_repo, name_pattern)
    VersionCollection.new(version_fetcher)
  end
end
