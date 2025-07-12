# spec/models/room_spec.rb
require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(title: "A fantasy game", user: user, theme: theme) }

  it 'is valid with a title, description, and game' do
    room = Room.create!(title: 'Twilight Hollow', description: 'A stone chamber glowing faintly under moonlight.', game: game)
    expect(room).to be_valid
  end

  it 'is invalid without a title' do
    room = Room.new(description: 'A stone chamber.', game: game)
    expect(room).not_to be_valid
  end

  it 'is invalid without a description' do
    room = Room.new(title: 'Twilight Hollow', game: game)
    expect(room).not_to be_valid
  end

  it 'is invalid without a game' do
    room = Room.new(title: 'Twilight Hollow', description: 'A stone chamber.')
    expect(room).not_to be_valid
  end
end
