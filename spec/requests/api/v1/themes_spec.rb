# spec/requests/api/v1/themes_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Themes', type: :request do
  let!(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic and mystery.') }

  describe 'GET /api/v1/themes' do
    it 'returns all themes' do
      get '/api/v1/themes'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json[0]['name']).to eq('fantasy')
      expect(json[0]['description']).to eq('A world of magic and mystery.')
    end
  end
end
