module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        render json: {
          message: 'Logged in successfully.',
          user: resource
        }, status: :ok
      end

      def respond_to_on_destroy
        head :no_content
      end

      def verify_signed_out_user
        # disables Devise's default flash behavior for sign out
      end
    end
  end
end
