Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote
      delete :unvote
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, except: :index, concerns: [:votable, :commentable]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :comments, only: :destroy
  resources :users, only: :show

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
