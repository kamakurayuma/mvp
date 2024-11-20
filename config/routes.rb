Rails.application.routes.draw do
  root "static_pages#top"
  resources :users, only: %i[new create show]
  resources :boards, only: %i[index new create show edit update destroy] 
  resources :cameras, only: [:create]
  resource :profile, only: %i[show edit update]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end