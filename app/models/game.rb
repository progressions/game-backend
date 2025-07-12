# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :rooms, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :player_histories, through: :players
  has_many :connections, through: :rooms
  validates :user, :theme, presence: true
end
