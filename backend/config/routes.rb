Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :categorias, only: [:index, :create]
      resources :links,      only: [:index]
    end
  end
end
