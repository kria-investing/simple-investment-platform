Rails.application.routes.draw do
  root "dashboards#index"

  resources :users
  resources :fundraises
end
