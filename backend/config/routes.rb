Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Autenticação admin
      post 'auth/login', to: 'auth#login'

      # Recursos
      resources :categorias,     only: [:index, :show, :create, :update, :destroy]
      resources :links,           only: [:index, :show, :create, :update, :destroy]
      resources :secoes,          only: [:index, :create, :update, :destroy]
      resources :areas_tecnicas,  only: [:index]
    end
  end
end
