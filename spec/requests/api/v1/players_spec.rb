# spec/requests/api/v1/players_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Players', type: :request do
  let(:room1) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.') }
  let(:room2) { Room.create!(title: 'Mossy Glade', description: 'A clearing with glowing flowers.') }
  let(:connection) { Connection.create!(from_room: room1, to_room: room2, label: 'Mossy Trail', description: 'A winding path.') }
  let(:player) { Player.create!(current_room: room1) }

  describe 'GET /api/v1/players/:id' do
    before { connection } # Ensure connection is created

    it 'returns a player with their current room and connections' do
      get "/api/v1/players/#{player.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['current_room']['title']).to eq('Twilight Hollow')
      expect(json['current_room']['connections'].first['label']).to eq('Mossy Trail')
    end

    it 'returns 404 for a non-existent player' do
      get '/api/v1/players/00000000-0000-0000-0000-000000000000'
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Player not found')
    end
  end

  describe 'POST /api/v1/players' do
    it 'creates a new player with a current room' do
      post '/api/v1/players', params: { player: { current_room_id: room1.id } }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['current_room_id']).to eq(room1.id)
      expect(PlayerHistory.exists?(player_id: json['id'], room_id: room1.id)).to be true
    end

    it 'returns 422 for invalid params' do
      post '/api/v1/players', params: { player: { current_room_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Current room must exist")
    end
  end

  describe 'POST /api/v1/players/:id/move' do
    before { connection } # Ensure connection is created

    it 'moves the player to a connected room' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'Mossy Trail' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Moved through Mossy Trail.')
      expect(json['room']['title']).to eq('Mossy Glade')
      expect(Player.find(player.id).current_room_id).to eq(room2.id)
      expect(PlayerHistory.exists?(player_id: player.id, room_id: room2.id)).to be true
    end

    it 'handles look action' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'look' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('You look around Twilight Hollow.')
      expect(json['room']['title']).to eq('Twilight Hollow')
    end

    it 'returns 422 for ungenerated destination room' do
      connection.update!(to_room: nil)
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'Mossy Trail' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Destination room not yet generated')
    end

    it 'returns 400 for invalid action' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'jump' }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq('Invalid action. Use a connection label or "look".')
    end
  end
end
