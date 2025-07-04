# spec/requests/api/v1/registrations_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Registrations', type: :request do
  describe 'POST /api/v1/signup' do
    context 'with valid params' do
      let(:valid_params) do
        {
          api_v1_user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a user and returns JWT' do
        post '/api/v1/signup', params: valid_params, as: :json

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Signed up successfully.')
        expect(json['user']['email']).to eq('newuser@example.com')
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          api_v1_user: {
            email: '',
            password: ''
          }
        }
      end

      it 'returns errors' do
        post '/api/v1/signup', params: invalid_params, as: :json

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank")
      end
    end
  end
end
