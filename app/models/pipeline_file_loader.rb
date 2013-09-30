class PipelineFileLoader
  class LoadError < StandardError; end

  def initialize(file_path)
    @file_path = file_path
  end

  def load
    pipeline_hash = read_file

    git_repo = build_git_repo(pipeline_hash["git_repo"])

    stages = pipeline_hash["stages"].map do |stage_hash|
      git_commits = build_git_commits(stage_hash["git_log"], git_repo)
      git_log     = build_git_log(stage_hash["git_log"], git_commits)
      stage       = build_stage(stage_hash, git_log)
    end

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
    local_dir  = hash["local_dir"]
    github_url = hash["github_url"]
    GitRepo.new(local_dir, github_url)
  end

  def build_stage(hash, git_log)
    Stage.new(hash["name"], git_log)
  end

  def build_git_log(hash, git_commits)
    symbolic_from = hash["from"]
    symbolic_to   = hash["to"]
    GitLog.new(symbolic_from, symbolic_to, git_commits)
  end

  def build_git_commits(hash, git_repo)
    symbolic_from = hash["from"]
    symbolic_to   = hash["to"]
    fetcher = GitCommitFetcher.new(
      git_repo, symbolic_from, symbolic_to)
    GitCommitCollection.new(fetcher)
  end
end
