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

      def index
        categorias = Categoria.all.order(:id_categoria)
        render json: categorias
      end

      def show
        categoria = Categoria.find(params[:id])
        render json: categoria
      end

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

      def update
        categoria = Categoria.find(params[:id])
        categoria.ds_categoria = categoria_params[:nome] if categoria_params[:nome].present?
        categoria.area_tecnica = Array(categoria_params[:areas]).join(',') if categoria_params.key?(:areas)
        categoria.icone = categoria_params[:icon] if categoria_params[:icon].present?

        if categoria.save
          render json: categoria
        else
          render json: { errors: categoria.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        categoria = Categoria.find(params[:id])
        categoria.destroy
        render json: { message: 'Categoria removida.' }, status: :ok
      end

      private

      def categoria_params
        params.permit(:nome, :icon, areas: [])
      end
    end
  end
end
