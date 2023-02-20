Rails.application.routes.draw do
  devise_for :users
  resourse "api"
  root "apis#index"

end
