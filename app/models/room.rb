class Room < ApplicationRecord
  belongs_to :game
  has_many :players, foreign_key: :current_room_id, dependent: :nullify

  # Connections where this room is the 'from' room
  has_many :outgoing_connections, class_name: "Connection", foreign_key: :from_room_id, dependent: :destroy
  # Connections where this room is the 'to' room
  has_many :incoming_connections, class_name: "Connection", foreign_key: :to_room_id, dependent: :destroy

  # Combine outgoing and incoming connections
  def connections
    Connection.where("from_room_id = :id OR to_room_id = :id", id: id)
  end
end
