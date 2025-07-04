module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      def create
        build_resource(sign_up_params)

        if resource.save
          warden.set_user(resource, scope: resource_name, store: false)
          render json: { message: 'Signed up successfully.', user: resource }, status: :ok
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:api_v1_user).permit(:email, :password, :password_confirmation)
      end

      protected

      def verify_signed_out_user
        # disables Devise's flash for API-only
      end
    end
  end
end
