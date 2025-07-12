# app/controllers/api/v1/games_controller.rb
module Api
  module V1
    class GamesController < ApplicationController
      before_action :authenticate_user
      before_action :set_game, only: [:show]

      def index
        games = Game.where(user_id: current_user.id)
        render json: games.as_json(include: { theme: { only: [:id, :name, :description] } })
      end

      def create
        game = Game.new(game_params.merge(user: current_user))
        if game.save
          render json: game, status: :created
        else
          render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: @game.as_json(include: { theme: { only: [:id, :name, :description] } })
      end

      private

      def set_game
        @game = Game.find_by(id: params[:id], user_id: current_user.id)
        render json: { errors: ['Game not found'] }, status: :not_found unless @game
      end

      def game_params
        params.require(:game).permit(:theme_id, :title)
      end
    end
  end
end
