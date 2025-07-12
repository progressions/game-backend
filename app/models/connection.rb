class Connection < ApplicationRecord
  belongs_to :from_room, class_name: "Room"
  belongs_to :to_room, class_name: "Room"

  validates :from_room_id, presence: true
  validates :to_room_id, presence: true
  validates :label, presence: true
end
