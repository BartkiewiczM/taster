# frozen_string_literal: true

class UserPreferences
  def initialize(user)
    @user = user
  end

  def fetch
    histories = MealHistory
                .includes(:meal)
                .where(user_id: user.id)
                .where("rating IS NOT NULL OR favourite = true")

    histories.map do |h|
      meal = h.meal
      "- Meal: #{meal.name}, Category: #{meal.category}, Ingredients: #{meal.ingredients}, Rating: #{h.rating}, Favourite: #{h.favourite}" # rubocop:disable Layout/LineLength
    end.join("\n")
  end

  private

  attr_reader :user
end
