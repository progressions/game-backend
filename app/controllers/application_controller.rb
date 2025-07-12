# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  require 'jwt'

  private

  def current_user
    token = request.headers['Authorization']&.split('Bearer ')&.last
    return unless token

    decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
    @current_user ||= User.find_by(id: decoded[0]['user_id'])
  rescue JWT::DecodeError
    nil
  end

  def authenticate_user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end
end
