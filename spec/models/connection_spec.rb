# spec/models/connection_spec.rb
require 'rails_helper'

RSpec.describe Connection, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(title: "A fantasy game", user: user, theme: theme) }
  let(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }

  it 'is valid with a from_room, to_room, label, and description' do
    connection = Connection.create!(from_room: room, label: 'Mossy Trail', description: 'A winding path of soft moss.')
    expect(connection).to be_valid
  end

  it 'is invalid without a label' do
    connection = Connection.new(from_room: room, description: 'A winding path.')
    expect(connection).not_to be_valid
  end

  it 'is invalid without a description' do
    connection = Connection.new(from_room: room, label: 'Mossy Trail')
    expect(connection).not_to be_valid
  end

  it 'is invalid without a from_room' do
    connection = Connection.new(label: 'Mossy Trail', description: 'A winding path.')
    expect(connection).not_to be_valid
  end
end
