Rails.application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'

  get "/healthz", to: "rails/health#show", as: :rails_health_check

  root "notes#new"

  get '/base64', to: "converters#base64", as: :base64

  resources :notes, except: [:index], path: "/"
end
