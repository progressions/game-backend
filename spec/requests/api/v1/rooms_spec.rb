# spec/requests/api/v1/rooms_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Rooms', type: :request do
  let!(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber glowing faintly under moonlight.') }
  let!(:connection) { Connection.create!(from_room: room, label: 'Mossy Trail', description: 'A winding path of soft moss.') }

  describe 'GET /api/v1/rooms' do
    it 'returns all rooms with their connections' do
      get '/api/v1/rooms'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json[0]['title']).to eq('Twilight Hollow')
      expect(json[0]['connections'][0]['label']).to eq('Mossy Trail')
    end
  end

  describe 'GET /api/v1/rooms/:id' do
    it 'returns a specific room with its connections' do
      get "/api/v1/rooms/#{room.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['title']).to eq('Twilight Hollow')
      expect(json['description']).to eq('A stone chamber glowing faintly under moonlight.')
      expect(json['connections'][0]['label']).to eq('Mossy Trail')
    end

    it 'returns 404 for a non-existent room' do
      get '/api/v1/rooms/00000000-0000-0000-0000-000000000000'
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Room not found')
    end
  end
end
