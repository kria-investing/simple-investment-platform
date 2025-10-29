require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root "dashboards#index"

  resources :users
  resources :fundraises
  resources :investments
end
