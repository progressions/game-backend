class Connection < ApplicationRecord
  belongs_to :from_room, class_name: "Room", optional: true
  belongs_to :to_room, class_name: "Room", optional: true

  validates :label, presence: true
  validate :at_least_one_room_present

  private

  def at_least_one_room_present
    if to_room_id.blank? && from_room_id.blank?
      errors.add(:base, "Connection must have at least one room (to_room_id or from_room_id)")
    end
  end
end
