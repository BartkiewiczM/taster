class PersistMeal
  def self.call(meal_data)
    Meal.find_or_create_by!(external_api_id: meal_data['idMeal']) do |m|
      m.name = meal_data['strMeal']
      m.category = meal_data['strCategory']
      m.recipe = meal_data['strInstructions']
      m.ingredients = extract_ingredients(meal_data).join("\n")
      m.image_url = meal_data['strMealThumb']
    end
  end

  def self.extract_ingredients(meal_data)
    (1..20).map do |i|
      ingredient = meal_data["strIngredient#{i}"]
      measure = meal_data["strMeasure#{i}"]
      "#{ingredient} - #{measure}" if ingredient.present? && ingredient.strip != ''
    end.compact
  end
end
