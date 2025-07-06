# frozen_string_literal: true

class ThemealdbMealSerializer
  def initialize(raw_data)
    @meal = raw_data
  end

  def as_json
    {
      id: @meal['idMeal'],
      name: @meal['strMeal'],
      category: @meal['strCategory'],
      ingredients: ingredients,
      recipe: @meal['strInstructions'],
      image_url: @meal['strMealThumb'],
      external_api_id: @meal['idMeal']
    }
  end

  private

  def ingredients
    (1..20).map do |i|
      ingredient = @meal["strIngredient#{i}"]
      measure = @meal["strMeasure#{i}"]
      "#{ingredient} - #{measure}" if ingredient.present? && ingredient.strip != ''
    end.compact
  end
end
