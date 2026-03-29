module Api
  module V1
    class LinksController < ApplicationController
      def index
        scope = Link.ativos.includes(:secao).order(:id_secao, :titulo)
        scope = scope.where(id_categoria: params[:id_categoria]) if params[:id_categoria].present?
        render json: scope
      end
    end
  end
end
