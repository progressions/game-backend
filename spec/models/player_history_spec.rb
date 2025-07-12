require 'rails_helper'

RSpec.describe PlayerHistory, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(title: "A fantasy game", user: user, theme: theme) }
  let(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }
  let(:player) { Player.create!(current_room: room, game: game) }

  it 'is valid with a player, room, and visited_at' do
    history = PlayerHistory.create!(player: player, room: room, visited_at: Time.now, game: game)
    expect(history).to be_valid
  end

  it 'is invalid without a player' do
    history = PlayerHistory.new(room: room, visited_at: Time.now, game: game)
    expect(history).not_to be_valid
  end

  it 'is invalid without a room' do
    history = PlayerHistory.new(player: player, visited_at: Time.now, game: game)
    expect(history).not_to be_valid
  end

  it 'is invalid without a visited_at' do
    history = PlayerHistory.new(player: player, room: room, game: game)
    expect(history).not_to be_valid
  end

  it 'is invalid without a game' do
    history = PlayerHistory.new(player: player, room: room, visited_at: Time.now)
    expect(history).not_to be_valid
  end
end
