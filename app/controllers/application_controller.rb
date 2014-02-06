class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def load_collection
    PipelineCollection.load_from_config_dir
  end

  def git_repo_clone(git_repo)
    @@git_repo_cloner ||= GitRepoCloner.new(Rails.logger)
    @@git_repo_cloner.clone(git_repo, avoid_fetch: param_true?(:avoid_fetch))
  rescue GitRepoCloner::Error => e
    @git_repo_clone_error = e
  end

  def param_true?(param_name)
    %w(1 t true y yes).include?(params[param_name])
  end

  def param_int(param_name, default_int)
    params[param_name].try(&:to_i) || default_int
  end
end
