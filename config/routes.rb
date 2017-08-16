require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    jsonapi_resources :heros
    jsonapi_resources :abilities
  end
end
