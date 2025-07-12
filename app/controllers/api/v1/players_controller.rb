# app/controllers/api/v1/players_controller.rb
module Api
  module V1
    class PlayersController < ApplicationController
      before_action :set_player, only: [:show, :move]

      def show
        render json: @player, include: { current_room: { include: { connections: { only: [:id, :label, :description, :to_room_id] } } } }
      end

      def create
        player = Player.new(player_params)
        if player.save
          PlayerHistory.create!(player: player, room: player.current_room, visited_at: Time.now)
          render json: player, status: :created
        else
          render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def move
        action = params[:action_text].downcase
        connection = @player.current_room.connections.find { |c| action.include?(c.label.downcase) }

        if connection
          if connection.to_room
            @player.update!(current_room: connection.to_room)
            PlayerHistory.create!(player: @player, room: connection.to_room, visited_at: Time.now)
            render json: {
              message: "Moved through #{connection.label}.",
              player: @player,
              room: connection.to_room,
              connections: connection.to_room.connections.as_json(only: [:id, :label, :description, :to_room_id])
            }
          else
            render json: { error: 'Destination room not yet generated' }, status: :unprocessable_entity
          end
        elsif action.match?(/\A(look|examine)\b/)
          render json: {
            message: "You look around #{@player.current_room.title}.",
            room: @player.current_room,
            connections: @player.current_room.connections.as_json(only: [:id, :label, :description, :to_room_id])
          }
        else
          render json: { error: 'Invalid action. Use a connection label or "look".' }, status: :bad_request
        end
      end

      private

      def set_player
        @player = Player.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Player not found' }, status: :not_found
      end

      def player_params
        params.require(:player).permit(:current_room_id)
      end
    end
  end
end
