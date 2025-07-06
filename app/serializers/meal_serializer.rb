class MealSerializer
  def initialize(meal)
    @meal = meal
  end

  def as_json
    {
      id: @meal.id,
      name: @meal.name,
      category: @meal.category,
      recipe: @meal.recipe,
      ingredients: @meal.ingredients&.split("\n"),
      image_url: @meal.image_url,
      external_api_id: @meal.external_api_id
    }
  end
end
