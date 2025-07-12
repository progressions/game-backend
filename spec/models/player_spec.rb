require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(user: user, theme: theme) }
  let(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }

  it 'is valid with a current_room and game' do
    player = Player.create!(current_room: room, game: game)
    expect(player).to be_valid
  end

  it 'is invalid without a current_room' do
    player = Player.new(game: game)
    expect(player).not_to be_valid
  end

  it 'is invalid without a game' do
    player = Player.new(current_room: room)
    expect(player).not_to be_valid
  end
end
