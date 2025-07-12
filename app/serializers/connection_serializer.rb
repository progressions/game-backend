class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :label, :to_room_id, :from_room_id
  belongs_to :to_room, serializer: RoomSerializer, if: -> { object.to_room.present? }
  belongs_to :from_room, serializer: RoomSerializer, if: -> { object.from_room.present? }
end
