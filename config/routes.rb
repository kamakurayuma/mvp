Rails.application.routes.draw do
  get "images/ogp"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "static_pages#top"
  get '/terms_of_service', to: 'static_pages#terms_of_service', as: 'terms_of_service'
  get '/privacy_policy', to: 'static_pages#privacy_policy', as: 'privacy_policy'

  resources :users, only: %i[new create show]
  resource :user_sessions, only: [:new, :create, :destroy]

  resources :boards, only: %i[index show new create edit update destroy] do
    collection do
      get 'search', to: 'boards#search'
      get :autocomplete
      get 'by_camera_make', to: 'boards#by_camera_make'  
      get :bookmarks
    end
  end

  resources :bookmarks, only: %i[create destroy]

  resources :cameras, only: [:create]
  resource :profile, only: %i[show edit update]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :password_resets, only: %i[new create edit update]

  get 'camera_make/:make', to: 'boards#by_camera_make', as: :by_camera_make
  get 'camera_model/:model', to: 'boards#by_camera_model', as: :by_camera_model

  get 'cameras/search', to: 'cameras#search'
  get 'boards/search', to: 'boards#search'
  get 'autocomplete', to: 'boards#autocomplete'
  get 'autocomplete', to: 'autocomplete#index'
  post 'add_camera_model', to: 'boards#add_camera_model'

  get 'top', to: 'static_pages#top', as: 'static_pages_top'

  post 'save_camera_model', to: 'camera_models#save'

  post '/oauth/google', to: 'oauths#oauth'
  post 'oauth/google', to: 'oauths#google'
  get '/oauth/google', to: 'oauths#oauth', as: 'google_oauth'
  get '/oauth/callback', to: 'oauths#callback', as: 'google_oauth_callback'
  get '/oauth/callback', to: 'oauths#callback'
end
