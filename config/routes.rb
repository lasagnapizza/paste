Rails.application.routes.draw do
  get "/healthz", to: "rails/health#show", as: :rails_health_check

  root "notes#new"

  resources :notes, except: [:index], path: "/"
end
