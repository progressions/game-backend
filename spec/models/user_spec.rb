# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with an email and password' do
    user = User.create!(email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid without a password' do
    user = User.new(email: 'test@example.com')
    expect(user).not_to be_valid
  end

  it 'is invalid with duplicate email' do
    User.create!(email: 'test@example.com', password: 'password123')
    user = User.new(email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end
end
