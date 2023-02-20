Rails.application.routes.draw do
  resources :apis
  devise_for :users
  resources "api"
  root "apis#index"

end
