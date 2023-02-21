Rails.application.routes.draw do
  resources :apis
  devise_for :users
  root "apis#index"

  post '/convert_to_speech/', to: 'apis#convert_to_speech'

end
