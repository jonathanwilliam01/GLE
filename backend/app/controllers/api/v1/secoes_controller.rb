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

      def create
        secao = Secao.new(
          ds_secao:    params[:nome].to_s.strip,
          sigla_secao: params[:sigla].to_s.strip.presence
        )
        if secao.save
          render json: { id: secao.id_secao, nome: secao.ds_secao, sigla: secao.sigla_secao }, status: :created
        else
          render json: { errors: secao.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        secao = Secao.find(params[:id])
        secao.ds_secao    = params[:nome].to_s.strip if params[:nome].present?
        secao.sigla_secao = params[:sigla].to_s.strip.presence if params.key?(:sigla)

        if secao.save
          render json: { id: secao.id_secao, nome: secao.ds_secao, sigla: secao.sigla_secao }
        else
          render json: { errors: secao.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        secao = Secao.find(params[:id])
        secao.destroy
        render json: { message: 'Seção removida.' }, status: :ok
      end
    end
  end
end
