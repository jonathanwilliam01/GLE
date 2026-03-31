module Api
  module V1
    class SecoesController < ApplicationController
      def index
        secoes = Secao.order(:id_secao)
        render json: secoes.map { |s|
          {
            id: s.id_secao,
            nome: s.ds_secao,
            sigla: s.sigla_secao
          }
        }
      end
    end
  end
end
