# frozen_string_literal: true

module Api
  module V1
    class MealHistoriesController < ApplicationController
      before_action :authenticate_api_v1_user!

      def index
        user = current_api_v1_user
      
        if favourites?
          meal_histories = 
            user.meal_histories.where(favourite: true)
                .order(created_at: :desc).includes(:meal).limit(10)
        else
          meal_histories = user.meal_histories.order(created_at: :desc).includes(:meal).limit(10)
        end
      
        if meal_histories.empty?
          render json: { message: 'No meal history found.' }, status: :not_found
        else
          render json: MealHistorySerializer.new(meal_histories).as_json, status: :ok
        end
      end

      def update
        user = current_api_v1_user
        meal_history = user.meal_histories.find_by(id: params[:id])
      
        unless meal_history
          render json: { error: 'Meal history not found' }, status: :not_found and return
        end
      
        if meal_history.update(update_params)
          render json: MealHistorySerializer.new([meal_history]).as_json.first, status: :ok
        else
          render json: { errors: meal_history.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      private
      
      def update_params
        params.require(:meal_history).permit(:favourite, :rating)
      end

      def favourites?
        params[:favourite].present? && ActiveModel::Type::Boolean.new.cast(params[:favourite])
      end
    end
  end
end
