# spec/requests/api/v1/players_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Players', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let(:game) { Game.create!(user: user, theme: theme) }
  let!(:room1) { Room.create!(title: 'Twilight Hollow', description: 'A stone chamber.', game: game) }
  let!(:room2) { Room.create!(title: 'Mossy Glade', description: 'A clearing with glowing flowers.', game: game) }
  let!(:connection) { Connection.create!(from_room: room1, to_room: room2, label: 'Mossy Trail', description: 'A winding path.') }
  let!(:player) { Player.create!(current_room: room1, game: game) }
  let(:token) do
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base, 'HS256')
  end

  describe 'GET /api/v1/players/:id' do
    it 'returns a player with their current room and connections' do
      get "/api/v1/players/#{player.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['current_room']['title']).to eq('Twilight Hollow')
      expect(json['current_room']['connections'].first['label']).to eq('Mossy Trail')
    end

    it 'returns 404 for a player not in user’s games' do
      other_user = User.create!(email: 'other@example.com', password: 'password123')
      other_game = Game.create!(user: other_user, theme: theme)
      other_player = Player.create!(current_room: room1, game: other_game)
      get "/api/v1/players/#{other_player.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('Player not found')
    end
  end

  describe 'POST /api/v1/players' do
    it 'creates a new player with a current room' do
      post '/api/v1/players', params: { player: { current_room_id: room1.id, game_id: game.id } }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['current_room_id']).to eq(room1.id)
      expect(json['game_id']).to eq(game.id)
      expect(PlayerHistory.exists?(player_id: json['id'], room_id: room1.id)).to be true
    end

    it 'returns 422 for invalid params' do
      post '/api/v1/players', params: { player: { current_room_id: nil, game_id: game.id } }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Current room must exist')
    end

    it 'returns 422 if room and game do not match' do
      other_game = Game.create!(user: user, theme: theme)
      post '/api/v1/players', params: { player: { current_room_id: room1.id, game_id: other_game.id } }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Room must belong to the specified game')
    end
  end

  describe 'POST /api/v1/players/:id/move' do
    it 'moves the player to a connected room' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'mossy trail' }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Moved through Mossy Trail.')
      expect(json['room']['title']).to eq('Mossy Glade')
      expect(Player.find(player.id).current_room_id).to eq(room2.id)
      expect(PlayerHistory.exists?(player_id: player.id, room_id: room2.id)).to be true
    end

    it 'handles look action' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'look' }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('You look around Twilight Hollow.')
      expect(json['room']['title']).to eq('Twilight Hollow')
    end

    it 'returns 422 for ungenerated destination room' do
      connection.update!(to_room: nil)
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'mossy trail' }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Destination room not yet generated')
    end

    it 'returns 422 for destination room not in player’s game' do
      other_game = Game.create!(user: user, theme: theme)
      other_room = Room.create!(title: 'Other Room', description: 'A different place.', game: other_game)
      connection.update!(to_room: other_room)
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'mossy trail' }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Destination room does not belong to the player’s game')
    end

    it 'returns 400 for invalid action' do
      post "/api/v1/players/#{player.id}/move", params: { action_text: 'jump' }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['errors']).to include('Invalid action. Use a connection label or "look".')
    end
  end
end
