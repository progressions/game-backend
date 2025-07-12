# spec/requests/api/v1/rooms_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Rooms', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(title: "A fantasy game", user: user, theme: theme) }
  let!(:room) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }
  let!(:connection) { Connection.create!(from_room: room, label: 'Mossy Trail', description: 'A winding path.') }
  let(:token) do
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base, 'HS256')
  end

  describe 'GET /api/v1/rooms' do
    it 'returns all rooms for the user’s games' do
      get '/api/v1/rooms', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json[0]['title']).to eq('Twilight Hollow')
      expect(json[0]['connections'][0]['label']).to eq('Mossy Trail')
    end

    it 'returns 401 if not authenticated' do
      get '/api/v1/rooms'
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Unauthorized')
    end
  end

  describe 'GET /api/v1/rooms/:id' do
    it 'returns a specific room with its connections' do
      get "/api/v1/rooms/#{room.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['title']).to eq('Twilight Hollow')
      expect(json['connections'][0]['label']).to eq('Mossy Trail')
    end

    it 'returns 404 for a room not in user’s games' do
      other_user = User.create!(email: 'other@example.com', password: 'password123')
      other_game = Game.create!(title: "Other Game", user: other_user, theme: theme)
      other_room = Room.create!(title: 'Other Room', description: 'A different place.', game: other_game)
      get "/api/v1/rooms/#{other_room.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('Room not found')
    end
  end
end
