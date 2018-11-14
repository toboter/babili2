require 'sidekiq/web'

Rails.application.routes.draw do
  get 'profiles/show'
  namespace :settings do
    get 'organizations/index'
  end
  get 'organizations/new'
  namespace :settings do
    get 'securities/show'
  end
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users

  namespace :settings do
    get '/', to: redirect("/settings/profile/edit")
    resource :profile, only: [:new, :create, :edit, :update], path_names: { new: 'generate' }
    devise_scope :user do
      get "/account" => "/devise/registrations#edit"
    end
    resources :organizations do
      resources :memberships, only: :destroy do
        put :approve, on: :member
      end
    end
    resource :security, only: :show do
      resources :user_sessions, only: :destroy
    end
    resources :oauth_authorized_applications
    resources :users, only: :index do 
      member do
        patch :approve
        patch :make_admin
      end
    end
    resources :oauth_applications
    resources :personal_access_tokens
  end

  namespace :setup do
    resources :organizations, only: [:create, :show, :update] do
      resources :build, controller: 'organizations'
    end
  end

  resources :organizations, only: :index do
    resources :memberships, only: :create #apply
  end

  root to: "home#index"

  resources :profiles, only: :show, path: '' do
    resources :workspaces do
      resources :nodes
    end
  end
end
