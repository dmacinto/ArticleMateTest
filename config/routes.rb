Rails.application.routes.draw do
  resources :apis
  devise_for :users
  root "apis#index"

end
