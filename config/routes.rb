Rails.application.routes.draw do
  root to: "home#index"

  resource :session
  
  resources :passwords

  namespace :reward do
    root to: "reward#menu"
    resources :reward
    resources :master
  end

  resources :user
end
