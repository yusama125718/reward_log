Rails.application.routes.draw do
  root to: "home#index"

  resource :session
  
  namespace :passwords do
    get :edit
    post :update
  end

  namespace :reward do
    root to: "reward#menu"
    resources :reward
    resources :master
  end

  resources :user
end
