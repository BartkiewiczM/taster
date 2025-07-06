# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MealHistorySerializer do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:meal) do
    Meal.create!(
      name: 'Pizza',
      category: 'Fast Food',
      image_url: 'http://example.com/pizza.jpg',
      external_api_id: 'ext-123'
    )
  end

  let(:meal_history) do
    user.meal_histories.create!(
      meal: meal,
      favourite: true,
      rating: 5
    )
  end

  subject { described_class.new([meal_history]).as_json }

  it 'serializes meal history with correct fields' do
    serialized = subject.first

    expect(serialized[:id]).to eq(meal_history.id)
    expect(serialized[:meal_id]).to eq(meal.external_api_id)
    expect(serialized[:name]).to eq(meal.name)
    expect(serialized[:category]).to eq(meal.category)
    expect(serialized[:image_url]).to eq(meal.image_url)
    expect(serialized[:created_at].to_s).to eq(meal_history.created_at.to_s)
    expect(serialized[:favorite]).to eq(true)
    expect(serialized[:rating]).to eq(5)
  end
end
