# ==================================================
# Controller: CategoriasController
# Responsabilidade: gerenciar requisições HTTP para /api/v1/categorias
# ==================================================
# Rotas atendidas:
#   GET  /api/v1/categorias       → index  (lista todas)
#   POST /api/v1/categorias       → create (cria uma nova)
# ==================================================

module Api
  module V1
    class CategoriasController < ApplicationController

      # GET /api/v1/categorias
      # Retorna todas as categorias ordenadas pelo ID
      def index
        categorias = Categoria.all.order(:id_categoria)
        render json: categorias
      end

      # POST /api/v1/categorias
      # Cria uma nova categoria com os dados recebidos do frontend
      def create
        categoria = Categoria.new(
          ds_categoria: categoria_params[:nome],
          area_tecnica: Array(categoria_params[:areas]).join(','),
          icone:        categoria_params[:icon].presence || 'pi pi-folder'
        )

        if categoria.save
          render json: categoria, status: :created
        else
          render json: { errors: categoria.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def categoria_params
        params.permit(:nome, :icon, areas: [])
      end
    end
  end
end
