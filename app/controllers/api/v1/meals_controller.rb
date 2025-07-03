module Api
  module V1
    class MealsController < ApplicationController
      before_action :set_meal, only: [:show]

      def index
        meals = Meal.all
        render json: meals, status: :ok
      end

      def show
        render json: @meal, status: :ok
      end

      def random
        meal = Meal.order('RANDOM()').first
        render json: meal, status: :ok
      end

      private

      def set_meal
        @meal = Meal.find(params[:id])
      end
    end
  end
end
