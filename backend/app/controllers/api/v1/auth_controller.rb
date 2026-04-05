module Api
  module V1
    class AuthController < ApplicationController

      def login
        user = params[:user]
        senha = params[:senha]

        if user == ENV['USER_ADMIN'] && senha == ENV['SENHA_ADMIN']
          render json: { admin: true }, status: :ok
        else
          render json: { error: 'Credenciais inválidas.' }, status: :unauthorized
        end
      end

    end
  end
end
