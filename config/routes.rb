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

      get :open_modal
      get :set_modal_params
      get :serch_content_type
      get :serch_job
      get :paginate
    end
  end

  namespace :master do
    root to: "master#index"
    resources :job do
      collection do
        get :paginate
      end
    end
    resources :content do
      collection do
        get :paginate
      end
    end
    resources :display do
      collection do
        get :paginate
      end
    end
  end

  resources :users do
    collection do
      get :paginate
    end
  end

  resources :display do
    member do
      get :show_image
      get :download
    end
    collection  do
      get :open_modal
      get :set_modal_params
      get :serch_type
      get :paginate
    end
  end
end
