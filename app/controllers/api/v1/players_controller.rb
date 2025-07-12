# app/controllers/api/v1/players_controller.rb
module Api
  module V1
    class PlayersController < ApplicationController
      before_action :authenticate_user
      before_action :set_player, only: [:show, :move]

      def show
        render json: @player.as_json(include: { current_room: { include: { connections: { only: [:id, :label, :description, :to_room_id] } } } })
      end

      def create
        player = Player.new(player_params)
        if player.current_room && player.game && player.current_room.game_id != player.game_id
          render json: { errors: ['Room must belong to the specified game'] }, status: :unprocessable_entity
        elsif player.save
          PlayerHistory.create!(player: player, room: player.current_room, game: player.game, visited_at: Time.now)
          render json: player, status: :created
        else
          render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def move
        action = params[:action_text]&.downcase&.strip
        Rails.logger.debug "Searching for connection with label: #{action}"
        connection = @player.current_room.connections.find_by("LOWER(label) = ?", action)

        if connection
          if connection.to_room
            if connection.to_room.game_id == @player.game_id
              @player.update!(current_room: connection.to_room)
              PlayerHistory.create!(player: @player, room: connection.to_room, game: @player.game, visited_at: Time.now)
              render json: {
                message: "Moved through #{connection.label}.",
                player: @player,
                room: connection.to_room,
                connections: connection.to_room.connections.as_json(only: [:id, :label, :description, :to_room_id])
              }
            else
              render json: { errors: ['Destination room does not belong to the player’s game'] }, status: :unprocessable_entity
            end
          else
            render json: { errors: ['Destination room not yet generated'] }, status: :unprocessable_entity
          end
        elsif action&.match?(/\A(look|examine)\b/)
          render json: {
            message: "You look around #{@player.current_room.title}.",
            room: @player.current_room,
            connections: @player.current_room.connections.as_json(only: [:id, :label, :description, :to_room_id])
          }
        else
          render json: { errors: ['Invalid action. Use a connection label or "look".'] }, status: :bad_request
        end
      end

      private

      def set_player
        @player = Player.joins(:game).where(games: { user_id: current_user.id }).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Player not found'] }, status: :not_found
      end

      def player_params
        params.require(:player).permit(:current_room_id, :game_id)
      end
    end
  end
end
