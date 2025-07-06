# frozen_string_literal: true

class MealHistorySerializer
  def initialize(raw_data)
    @meal_histories = raw_data
  end

  def as_json
    @meal_histories.map do |meal_history|
      {
        id: meal_history.id,
        meal_id: meal_history.meal.external_api_id,
        name: meal_history.meal.name,
        category: meal_history.meal.category,
        description: meal_history.meal&.description,
        image_url: meal_history.meal&.image_url,
        created_at: meal_history.created_at,
        favorite: meal_history.favourite,
        rating: meal_history&.rating
      }
    end
  end
end
