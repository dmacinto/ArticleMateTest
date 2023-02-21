Rails.application.routes.draw do
  resources :apis
  devise_for :users
  root "apis#index"

  get '/convert_to_speech/:id', to: 'pub_med#convert_to_speech'

end
