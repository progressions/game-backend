# app/models/theme.rb
class Theme < ApplicationRecord
  validates :name, :description, presence: true
end
