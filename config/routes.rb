GitPipeline::Application.routes.draw do
  root to: "pipelines#index"
  resources :pipelines
end
