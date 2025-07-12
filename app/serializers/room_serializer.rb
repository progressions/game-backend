class RoomSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  has_many :connections, serializer: ConnectionSerializer
end
