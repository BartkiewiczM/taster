# frozen_string_literal: true

module Api
  module V1
    class MealsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def random
        meal_data = ThemealdbService.random_meal(params[:category])

        if meal_data.blank?
          render json: { error: 'Meal not found in category' }, status: :not_found
          return
        end

        meal = PersistMeal.call(meal_data)

        user = current_api_v1_user
        unless user.meals.exists?(external_api_id: meal.external_api_id)
          user.meals << meal
        end

        render json: ThemealdbMealSerializer.new(meal_data).as_json, status: :ok
      end
    end
  end
end
