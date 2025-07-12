# app/controllers/api/v1/rooms_controller.rb
module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authenticate_user
      before_action :set_room, only: [:show]

      def index
        rooms = Room.joins(:game).where(games: { user_id: current_user.id })
        render json: rooms.as_json(include: { connections: { only: [:id, :label, :description, :to_room_id] } })
      end

      def show
        render json: @room.as_json(include: { connections: { only: [:id, :label, :description, :to_room_id] } })
      end

      private

      def set_room
        @room = Room.joins(:game).where(games: { user_id: current_user.id }).find_by(id: params[:id])
        render json: { errors: ['Room not found'] }, status: :not_found unless @room
      end
    end
  end
end
