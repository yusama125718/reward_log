Rails.application.routes.draw do
  root to: "home#index"

  resource :session
  
  namespace :passwords do
    get :edit
    post :update
  end

  resources :reward do
    collection  do
      get :job_index
      get :content_index
    end
  end

  namespace :master do
    root to: "master#index"
    resources :job
    resources :content
  end

  resources :users
end
