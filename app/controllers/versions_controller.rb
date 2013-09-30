class VersionsController < ApplicationController
  def index
    @pipeline = load_collection.find_by_id(params[:pipeline_id])
    @linker   = GithubLinker.new(@pipeline.git_repo.github_url)
    git_repo_clone(@pipeline.git_repo)
  end
end
