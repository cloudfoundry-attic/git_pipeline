class PipelinesController < ApplicationController
  def index
    @pipelines = load_collection
  end

  def show
    @pipeline = load_collection.find_by_id(params[:id])
    @linker_factory = LinkerFactory.new
    @hide_submodules = param_true?(:hide_submodules)
    git_repo_clone(@pipeline.git_repo)
  end
end
