module Api
  module V1
    class MealsController < ApplicationController
      def random
        meal_data = ThemealdbService.random_meal(params[:category])

        if meal_data.present?
          render json: ThemealdbMealSerializer.new(meal_data).as_json, status: :ok
        else
          render json: { error: 'Meal not found in category' }, status: :not_found
        end
      end
    end
  end
end
