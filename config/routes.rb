Rails.application.routes.draw do
  devise_for :users

  resources :customers, only: :index

  root to: "dashboard#index"
end
