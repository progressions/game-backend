require 'rails_helper'

RSpec.describe Connection, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'Fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(title: 'A Fantasy Game', user: user, theme: theme) }
  let(:room1) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }
  let(:room2) { Room.create!(title: 'Mossy Glade', description: 'A lush clearing.', game: game) }

  describe 'validations' do
    it 'is valid with both from_room and to_room' do
      connection = Connection.new(from_room: room1, to_room: room2, label: 'Mossy Trail')
      expect(connection).to be_valid
    end

    it 'is valid with only from_room' do
      connection = Connection.new(from_room: room1, label: 'Exit Hollow')
      expect(connection).to be_valid
    end

    it 'is valid with only to_room' do
      connection = Connection.new(to_room: room2, label: 'To Glade')
      expect(connection).to be_valid
    end

    it 'is invalid without a label' do
      connection = Connection.new(from_room: room1, to_room: room2)
      expect(connection).not_to be_valid
      expect(connection.errors[:label]).to include("can't be blank")
    end

    it 'is invalid without both from_room and to_room' do
      connection = Connection.new(label: 'Mossy Trail')
      expect(connection).not_to be_valid
      expect(connection.errors[:base]).to include("Connection must have at least one room (to_room_id or from_room_id)")
    end
  end
end
