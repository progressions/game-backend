class Connection < ApplicationRecord
  belongs_to :from_room
  belongs_to :to_room
end
