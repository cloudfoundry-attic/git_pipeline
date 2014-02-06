class VersionsController < ApplicationController
  def index
    @pipeline = load_collection.find_by_id(params[:pipeline_id])
    @linker_factory = LinkerFactory.new
    @max_with_submodules = param_int(:max_with_submodules, 2)
    git_repo_clone(@pipeline.git_repo)
  end
end
