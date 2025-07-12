# app/models/room.rb
class Room < ApplicationRecord
  belongs_to :game
  has_many :connections, foreign_key: :from_room_id, dependent: :destroy
  has_many :player_histories, dependent: :destroy
  validates :title, :description, presence: true
end
