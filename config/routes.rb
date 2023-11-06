Rails.application.routes.draw do
  get "/healthz", to: "rails/health#show", as: :rails_health_check

  root "notes#new"

  get '/base64', to: "converters#base64", as: :base64
  match '/html2haml', to: 'converters#html2haml', via: [:get, :post]

  resources :notes, except: [:index], path: "/"
end
