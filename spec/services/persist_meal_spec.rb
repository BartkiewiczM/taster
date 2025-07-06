# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersistMeal do
  describe '.call' do
    let(:meal_data) do
      {
        'idMeal' => '123',
        'strMeal' => 'Test Meal',
        'strCategory' => 'Dessert',
        'strInstructions' => 'Mix everything',
        'strMealThumb' => 'http://example.com/image.jpg',
        'strIngredient1' => 'Sugar',
        'strMeasure1' => '1 cup',
        'strIngredient2' => 'Flour',
        'strMeasure2' => '2 cups',
        'strIngredient3' => '',
        'strMeasure3' => ''
      }
    end

    it 'creates a new meal if it does not exist' do
      expect {
        PersistMeal.call(meal_data)
      }.to change { Meal.count }.by(1)

      meal = Meal.last
      expect(meal.external_api_id).to eq('123')
      expect(meal.name).to eq('Test Meal')
      expect(meal.category).to eq('Dessert')
      expect(meal.description).to eq('Mix everything')
      expect(meal.recipe).to eq('Mix everything')
      expect(meal.ingredients).to include('Sugar - 1 cup', 'Flour - 2 cups')
      expect(meal.image_url).to eq('http://example.com/image.jpg')
    end

    it 'returns the existing meal if already persisted' do
      existing = PersistMeal.call(meal_data)

      expect {
        result = PersistMeal.call(meal_data)
        expect(result).to eq(existing)
      }.not_to change { Meal.count }
    end
  end
end
