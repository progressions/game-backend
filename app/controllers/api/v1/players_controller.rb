module Api
  module V1
    class PlayersController < ApplicationController
      before_action :authenticate_user
      before_action :set_player, only: [:show, :move]

      def show
        render json: @player, serializer: PlayerSerializer
      end

      def create
        player = Player.new(player_params)
        return render json: { errors: ['Room must belong to the specified game'] }, status: :unprocessable_entity if invalid_room_game?(player)

        if player.save
          PlayerHistory.create!(player: player, room: player.current_room, game: player.game, visited_at: Time.now)
          render json: player, status: :created
        else
          render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def move
        room_id = params[:room_id]
        return render json: { errors: ['Room ID is required'] }, status: :bad_request unless room_id

        destination_room = Room.find_by(id: room_id)
        return render json: { errors: ['Destination room not found'] }, status: :not_found unless destination_room
        return render json: { errors: ['Destination room does not belong to the player’s game'] }, status: :unprocessable_entity unless destination_room.game_id == @player.game_id
        return render json: { errors: ['No valid connection to destination room'] }, status: :bad_request unless valid_connection?(@player.current_room, destination_room)

        move_player(destination_room)
        render json: {
          message: "Moved to #{destination_room.title}.",
          player: @player,
          room: destination_room,
          connections: destination_room.connections.as_json(only: [:id, :label, :to_room_id])
        }
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

      def invalid_room_game?(player)
        player.current_room && player.game && player.current_room.game_id != player.game_id
      end

      def valid_connection?(current_room, destination_room)
        current_room.connections.exists?(to_room_id: destination_room.id)
      end

      def move_player(room)
        @player.update!(current_room: room)
        PlayerHistory.create!(player: @player, room: room, game: @player.game, visited_at: Time.now)
      end
    end
  end
end
