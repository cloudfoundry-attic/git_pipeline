class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def load_collection
    PipelineCollection.load_from_config_dir
  end

  def git_repo_clone(git_repo)
    @@git_repo_cloner ||= GitRepoCloner.new
    @@git_repo_cloner.clone(git_repo)
  rescue GitRepoCloner::Error => e
    @git_repo_clone_error = e
  end
end
