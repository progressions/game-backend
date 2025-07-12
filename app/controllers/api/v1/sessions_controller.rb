# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < ApplicationController
      def create
        Rails.logger.debug "Login params: #{params.inspect}"
        user = User.find_by("LOWER(email) = ?", params[:email]&.downcase)
        Rails.logger.debug "Found user: #{user.inspect}"
        if user&.authenticate(params[:password])
          token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base, 'HS256')
          render json: { user_id: user.id, token: token, message: 'Logged in' }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        render json: { message: 'Logged out' }, status: :ok
      end
    end
  end
end
