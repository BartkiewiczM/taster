require 'rails_helper'

RSpec.describe MealSerializer do
  it 'serializes a meal correctly' do
    meal = Meal.create!(
      external_api_id: '321',
      name: 'Serializer Meal',
      category: 'Seafood',
      recipe: 'Cook it!',
      ingredients: "Fish - 1\nSalt - pinch",
      image_url: 'http://example.com/ser.jpg'
    )

    json = MealSerializer.new(meal).as_json

    expect(json[:id]).to eq(meal.id)
    expect(json[:name]).to eq('Serializer Meal')
    expect(json[:category]).to eq('Seafood')
    expect(json[:recipe]).to eq('Cook it!')
    expect(json[:ingredients]).to eq(['Fish - 1', 'Salt - pinch'])
    expect(json[:image_url]).to eq('http://example.com/ser.jpg')
    expect(json[:external_api_id]).to eq('321')
  end
end
