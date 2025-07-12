# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :games, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password
end
