Rails.application.routes.draw do
  get "/healthz", to: "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "notes#new"

  get '/:slug', to: "notes#show", as: :note

  resources :notes, except: [:index, :show]
end
