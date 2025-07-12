# spec/requests/api/v1/games_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Games', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }
  let!(:game) { Game.create!(user: user, theme: theme) }
  let(:token) do
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base, 'HS256')
  end

  describe 'GET /api/v1/games' do
    it 'returns all games for the user' do
      get '/api/v1/games', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json[0]['theme']['name']).to eq('fantasy')
    end

    it 'returns 401 if not authenticated' do
      get '/api/v1/games'
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Unauthorized')
    end
  end

  describe 'POST /api/v1/games' do
    it 'creates a new game with a theme' do
      post '/api/v1/games', params: { game: { theme_id: theme.id } }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['user_id']).to eq(user.id)
      expect(json['theme_id']).to eq(theme.id)
    end

    it 'returns 422 for invalid params' do
      post '/api/v1/games', params: { game: { theme_id: nil } }, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include('Theme must exist')
    end

    it 'returns 401 if not authenticated' do
      post '/api/v1/games', params: { game: { theme_id: theme.id } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Unauthorized')
    end
  end

  describe 'GET /api/v1/games/:id' do
    it 'returns a specific game' do
      get "/api/v1/games/#{game.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['theme']['name']).to eq('fantasy')
    end

    it 'returns 404 for a game not owned by user' do
      other_user = User.create!(email: 'other@example.com', password: 'password123')
      other_game = Game.create!(user: other_user, theme: theme)
      get "/api/v1/games/#{other_game.id}", headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('Game not found')
    end
  end
end
