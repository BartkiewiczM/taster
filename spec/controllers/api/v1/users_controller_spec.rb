# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #preferences' do
    let(:user) do
      User.create!(
        email: 'test@example.com',
        password: 'password123',
        preferences: 'My saved taste profile'
      )
    end

    before do
      sign_in user
    end

    it 'returns http success with user.preferences' do
      get :preferences, format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['preferences']).to eq('My saved taste profile')
    end

    it 'returns unauthorized if not signed in' do
      sign_out user

      get :preferences, format: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
