# app/models/player_history.rb
class PlayerHistory < ApplicationRecord
  belongs_to :player
  belongs_to :room
  validates :player, :room, :visited_at, presence: true
  belongs_to :game
end
