require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'store#index', as: :store_root
  end

  root to: 'visitors#index'

  resources :ovens do
    resource :cookies do
      post :bulk_create
    end
    member do
      post :empty
    end
  end

  resources :orders, only: [:index]

  namespace :api do
    resources :orders, only: [:index] do
      put :fulfill, on: :member
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  # mount MailPreview => 'mail_view' if Rails.env.development?
end
