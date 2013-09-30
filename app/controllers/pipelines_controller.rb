class PipelinesController < ApplicationController
  def index
    @pipelines = load_collection
  end

  def show
    @pipeline = load_collection.find_by_id(params[:id])
    @linker   = GithubLinker.new(@pipeline.git_repo.github_url)
    git_repo_cloner.clone(@pipeline.git_repo)
  end

  private

  def load_collection
    PipelineCollection.load_from_config_dir
  end

  def git_repo_cloner
    @@git_repo_cloner ||= GitRepoCloner.new
  end
end
