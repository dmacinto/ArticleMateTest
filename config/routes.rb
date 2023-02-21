Rails.application.routes.draw do
  resources :apis
  devise_for :users
  root "apis#index"

  get '/convert_to_speech/:id', to: 'api#convert_to_speech'

end
