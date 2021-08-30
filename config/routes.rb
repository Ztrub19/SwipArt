Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :artworks, only: %i[like dislike]
  resources :exhibitions, only: %i[show]
  resources :artworks, only: %i[create new edit update] do
    member do
      post 'like'
      post 'dislike'
    end
  end
  get 'dashboard', to: 'pages#dashboard'
end
