# app/controllers/api/v1/rooms_controller.rb
module Api
  module V1
    class RoomsController < ApplicationController
      before_action :set_room, only: [:show]

      def index
        rooms = Room.all
        render json: rooms, include: { connections: { only: [:id, :label, :description, :to_room_id] } }
      end

      def show
        render json: @room, include: { connections: { only: [:id, :label, :description, :to_room_id] } }
      end

      private

      def set_room
        @room = Room.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Room not found' }, status: :not_found
      end
    end
  end
end
