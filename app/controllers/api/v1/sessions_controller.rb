module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        warden.set_user(resource, scope: resource_name, store: false)

        token = request.env['warden-jwt_auth.token']

        render json: {
          message: 'Logged in successfully.',
          user: resource,
          token: token
        }, status: :ok
      end

      private

      def respond_to_on_destroy
        head :no_content
      end

      def verify_signed_out_user
        # disables Devise's default flash behavior for sign out
      end
    end
  end
end
