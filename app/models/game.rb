class Game < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  belongs_to :starting_room, class_name: "Room", optional: true
  has_many :rooms, dependent: :destroy

  validates :user, presence: true
  validates :theme, presence: true
  validates :title, presence: true

  before_destroy :clear_starting_room

  private

  def clear_starting_room
    update(starting_room_id: nil)
  end
end
