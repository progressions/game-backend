class PlayerSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :current_room
  belongs_to :game
end
