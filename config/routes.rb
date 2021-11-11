Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, except: :index
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show
end
