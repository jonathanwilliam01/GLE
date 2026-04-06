module Api
  module V1
    class LinksController < ApplicationController
      def index
        if params[:incluir_excluidos].present?
          scope = Link.includes(:secao, :categoria).order(:id_secao, :titulo)
        else
          scope = Link.ativos.includes(:secao, :categoria).order(:id_secao, :titulo)
        end
        scope = scope.where(id_categoria: params[:id_categoria]) if params[:id_categoria].present?
        scope = scope.where(id_secao: params[:id_secao]) if params[:id_secao].present?
        if params[:area_tecnica].present?
          scope = scope.where(area_tecnica: params[:area_tecnica])
        end
        render json: scope
      end

      def show
        link = Link.find(params[:id])
        render json: link
      end

      def create
        link = Link.new(link_params)
        if link.save
          render json: link, status: :created
        else
          render json: { errors: link.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        link = Link.find(params[:id])
        if link.update(link_params)
          render json: link
        else
          render json: { errors: link.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        link = Link.find(params[:id])
        link.update(ativo: false, dt_exclusao: Time.current)
        render json: { message: 'Link removido.' }, status: :ok
      end

      def reativar
        link = Link.find(params[:id])
        link.update(ativo: true, dt_exclusao: nil)
        render json: { message: 'Link reativado.' }, status: :ok
      end

      def top5
        links = Link.ativos.order(Arel.sql('COALESCE(qtd_cliques, 0) DESC')).limit(5)
        render json: links
      end

      def clique
        link = Link.find(params[:id])
        nova_qtd = (link.qtd_cliques || 0) + 1
        link.update_column(:qtd_cliques, nova_qtd)
        render json: { qtd_cliques: nova_qtd }, status: :ok
      end

      private

      def link_params
        params.permit(:titulo, :link, :ds_link, :id_categoria, :id_secao, :area_tecnica)
      end
    end
  end
end
