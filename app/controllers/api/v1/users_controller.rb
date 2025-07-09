# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!

      def preferences
        user = current_api_v1_user
        preferences = User.find(user.id).preferences

        render json: { preferences: preferences }, status: :ok
      end
    end
  end
end
