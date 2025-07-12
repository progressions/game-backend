# spec/requests/api/v1/sessions_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  describe 'POST /api/v1/login' do
    it 'logs in with valid credentials' do
      post '/api/v1/login', params: { email: 'test@example.com', password: 'password123' }, as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Logged in')
      expect(json['token']).to be_present
      expect(json['user_id']).to eq(user.id)
    end

    it 'returns unauthorized for invalid credentials' do
      post '/api/v1/login', params: { email: 'test@example.com', password: 'wrong' }, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
    end
  end

  describe 'DELETE /api/v1/logout' do
    it 'returns logout message' do
      delete '/api/v1/logout'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out')
    end
  end
end
