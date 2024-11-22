Rails.application.routes.draw do
  root "static_pages#top"
  resources :users, only: %i[new create show]
  resources :boards, only: %i[index new create show edit update destroy] 
  resources :cameras, only: [:create]
  resource :profile, only: %i[show edit update]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'camera_make/:make', to: 'boards#by_camera_make', as: :by_camera_make
  get 'camera_model/:model', to: 'boards#by_camera_model', as: :by_camera_model
end