# spec/models/player_history_spec.rb
require 'rails_helper'

RSpec.describe PlayerHistory, type: :model do
  let(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.') }
  let(:player) { Player.create!(current_room: room) }

  it 'is valid with a player, room, and visited_at' do
    history = PlayerHistory.create!(player: player, room: room, visited_at: Time.now)
    expect(history).to be_valid
  end

  it 'is invalid without a player' do
    history = PlayerHistory.new(room: room, visited_at: Time.now)
    expect(history).not_to be_valid
  end

  it 'is invalid without a room' do
    history = PlayerHistory.new(player: player, visited_at: Time.now)
    expect(history).not_to be_valid
  end

  it 'is invalid without a visited_at' do
    history = PlayerHistory.new(player: player, room: room)
    expect(history).not_to be_valid
  end
end
