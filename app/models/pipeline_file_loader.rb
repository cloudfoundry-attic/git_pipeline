class PipelineFileLoader
  class LoadError < StandardError; end

  def initialize(file_path)
    @file_path = file_path
  end

  def load
    pipeline_hash = read_file

    git_repo = build_git_repo(pipeline_hash["git_repo"])

    static_stages = pipeline_hash["stages"].map do |stage_hash|
      git_log = build_git_log(stage_hash["git_log"], git_repo)
      stage   = build_stage(stage_hash, git_log)
    end

    stages = build_stages(static_stages, git_repo)

    build_pipeline(pipeline_hash, git_repo, stages)
  end

  private

  def read_file
    YAML.load_file(@file_path)
  rescue SystemCallError => e
    raise LoadError, e.message
  end

  def build_pipeline(hash, git_repo, stages)
    id   = File.basename(@file_path, ".yml")
    name = hash["name"]
    Pipeline.new(id, name, git_repo, stages)
  end

  def build_git_repo(hash)
    GitRepo.new(hash["local_dir"], hash["github_url"])
  end

  def build_stages(static_stages, git_repo)
    fetcher = StageVersionFetcher.new(git_repo)
    StageCollection.new(static_stages, fetcher)
  end

  def build_stage(hash, git_log)
    Stage.new(hash["name"], git_log)
  end

  def build_git_log(hash, git_repo)
    GitLog.from_symbolic_range(
      git_repo, hash["from"], hash["to"])
  end
end
