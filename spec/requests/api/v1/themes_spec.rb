# spec/requests/api/v1/themes_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Themes', type: :request do
  let!(:themes) do
    Theme.create!([
      { name: 'fantasy', description: 'A world of magic and mystery.' },
      { name: 'action', description: 'A high-energy world of danger.' },
      { name: 'adventure', description: 'A vast world of exploration.' }
    ])
  end

  describe 'GET /api/v1/themes' do
    it 'returns all themes' do
      get '/api/v1/themes'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.first['name']).to eq('fantasy')
    end
  end
end
