# frozen_string_literal: true

class PersistMeal
  def self.call(meal_data)
    Meal.find_or_create_by!(external_api_id: meal_data['idMeal']) do |m|
      m.name = meal_data['strMeal']
      m.category = meal_data['strCategory']
      m.recipe = meal_data['strInstructions']
      m.ingredients = ThemealdbMealSerializer.new(meal_data).send(:ingredients).join("\n")
      m.image_url = meal_data['strMealThumb']
    end
  end
end
