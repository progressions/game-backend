# spec/models/room_spec.rb
require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'is valid with a title and description' do
    room = Room.create!(title: 'Twilight Hollow', description: 'A stone chamber glowing faintly under moonlight.')
    expect(room).to be_valid
  end

  it 'is invalid without a title' do
    room = Room.new(description: 'A stone chamber.')
    expect(room).not_to be_valid
  end

  it 'is invalid without a description' do
    room = Room.new(title: 'Twilight Hollow')
    expect(room).not_to be_valid
  end
end
