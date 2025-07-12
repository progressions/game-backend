class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :label, :description, :to_room_id
end
