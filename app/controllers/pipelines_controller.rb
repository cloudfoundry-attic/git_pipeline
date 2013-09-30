class PipelinesController < ApplicationController
  def index
    @pipelines = load_collection
  end

  def show
    @pipeline = load_collection.find_by_id(params[:id])
    @linker   = GithubLinker.new(@pipeline.git_repo.github_url)
    git_repo_clone(@pipeline.git_repo)
  end
end
