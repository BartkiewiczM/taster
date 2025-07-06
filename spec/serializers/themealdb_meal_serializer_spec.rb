# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThemealdbMealSerializer do
  let(:raw_data) do
    {
      'idMeal' => '1234',
      'strMeal' => 'Test Meal',
      'strCategory' => 'Dessert',
      'strInstructions' => 'Do something',
      'strMealThumb' => 'http://example.com/image.jpg',
      'strIngredient1' => 'Flour',
      'strMeasure1' => '200g',
      'strIngredient2' => 'Sugar',
      'strMeasure2' => '100g',
      'strIngredient3' => '',
      'strMeasure3' => ''
    }
  end

  it 'returns formatted hash' do
    result = described_class.new(raw_data).as_json
    expect(result).to include(
      id: '1234',
      name: 'Test Meal',
      category: 'Dessert',
      description: 'Do something',
      recipe: 'Do something',
      image_url: 'http://example.com/image.jpg',
      external_api_id: '1234'
    )
    expect(result[:ingredients]).to eq(['Flour - 200g', 'Sugar - 100g'])
  end
end
