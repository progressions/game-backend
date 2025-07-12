# spec/models/theme_spec.rb
require 'rails_helper'

RSpec.describe Theme, type: :model do
  it 'is valid with a name and description' do
    theme = Theme.create!(name: 'fantasy', description: 'A world of magic and mystery.')
    expect(theme).to be_valid
  end

  it 'is invalid without a name' do
    theme = Theme.new(description: 'A world of magic and mystery.')
    expect(theme).not_to be_valid
  end

  it 'is invalid without a description' do
    theme = Theme.new(name: 'fantasy')
    expect(theme).not_to be_valid
  end
end
