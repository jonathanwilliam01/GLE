Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Recursos
      resources :categorias, only: [:index, :show, :create, :update, :destroy]
      resources :links,      only: [:index, :show, :create, :update, :destroy]
      resources :secoes,     only: [:index]
    end
  end
end
