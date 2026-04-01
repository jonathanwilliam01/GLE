class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_error

  private

  def handle_error(e)
    Rails.logger.error("#{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace&.first(5)&.join("\n"))
    render json: { error: 'Erro interno do servidor.' }, status: :internal_server_error
  end
end
