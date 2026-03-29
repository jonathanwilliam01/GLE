class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_error

  private

  def handle_error(e)
    Rails.logger.error(e.message)
    render json: { error: 'Erro interno do servidor.' }, status: :internal_server_error
  end
end
