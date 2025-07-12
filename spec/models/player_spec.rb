# spec/models/player_spec.rb
require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.') }

  it 'is valid with a current_room' do
    player = Player.create!(current_room: room)
    expect(player).to be_valid
  end

  it 'is invalid without a current_room' do
    player = Player.new
    expect(player).not_to be_valid
  end
end
