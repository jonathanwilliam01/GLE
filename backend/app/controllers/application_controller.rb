class ApplicationController < ActionController::API
  before_action :authorize_request

  rescue_from StandardError, with: :handle_error

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header&.split(' ')&.last

    if token.blank?
      render json: { error: 'Token não fornecido.' }, status: :unauthorized
      return
    end

    decoded = JsonWebToken.decode(token)
    if decoded.nil?
      render json: { error: 'Token inválido ou expirado.' }, status: :unauthorized
      return
    end

    @current_user_id = decoded[:id] || decoded[:idUsuario]
  end

  def current_user_id
    @current_user_id
  end

  def handle_error(e)
    Rails.logger.error("#{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace&.first(5)&.join("\n"))
    render json: { error: 'Erro interno do servidor.' }, status: :internal_server_error
  end
end
