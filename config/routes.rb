Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote
      delete :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, except: :index, concerns: :votable
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :show
end
