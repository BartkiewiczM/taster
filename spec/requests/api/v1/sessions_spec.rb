require 'rails_helper'

RSpec.describe 'API::V1::Sessions', type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      let(:valid_params) do
        {
          api_v1_user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }
      end

      it 'logs in and returns JWT' do
        post '/api/v1/login', params: valid_params, as: :json

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Logged in successfully.')
        expect(json['user']['email']).to eq('test@example.com')
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) do
        {
          api_v1_user: {
            email: 'test@example.com',
            password: 'wrongpassword'
          }
        }
      end

      it 'returns unauthorized' do
        post '/api/v1/login', params: invalid_params, as: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/logout' do
    it 'logs out with no content' do
      delete '/api/v1/logout'
      expect(response).to have_http_status(204)
    end
  end
end
