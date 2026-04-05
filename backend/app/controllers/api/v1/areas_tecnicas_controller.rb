module Api
  module V1
    class AreasTecnicasController < ApplicationController
      def index
        areas = AreaTecnica.order(:id_area)
        render json: areas
      end
    end
  end
end
