class PipelinesController < ApplicationController
  def index
    @pipelines = load_collection
  end

  def show
    @pipeline = load_collection.find_by_id(params[:id])
    @linker   = GithubLinker.new(@pipeline.git_repo.github_url)
    git_repo_clone(@pipeline.git_repo)
  end

  private

  def git_repo_clone(git_repo)
    @@git_repo_cloner ||= GitRepoCloner.new
    @@git_repo_cloner.clone(git_repo)
  rescue GitRepoCloner::Error => e
    @git_repo_clone_error = e
  end

  def load_collection
    PipelineCollection.load_from_config_dir
  end
end
