# app/models/player.rb
class Player < ApplicationRecord
  belongs_to :game
  belongs_to :current_room, class_name: 'Room'
  has_many :player_histories, dependent: :destroy
  validates :current_room, presence: true
end
