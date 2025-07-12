# app/models/connection.rb
class Connection < ApplicationRecord
  belongs_to :from_room, class_name: 'Room'
  belongs_to :to_room, class_name: 'Room', optional: true
  validates :from_room, :label, :description, presence: true
end
