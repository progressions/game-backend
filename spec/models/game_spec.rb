require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:theme) { Theme.create!(name: 'fantasy', description: 'A world of magic.') }

  it 'is valid with a user and theme' do
    game = Game.create!(user: user, theme: theme)
    expect(game).to be_valid
  end

  it 'is invalid without a user' do
    game = Game.new(theme: theme)
    expect(game).not_to be_valid
  end

  it 'is invalid without a theme' do
    game = Game.new(user: user)
    expect(game).not_to be_valid
  end
end
