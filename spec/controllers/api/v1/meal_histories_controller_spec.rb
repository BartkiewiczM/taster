# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MealHistoriesController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:meal) { Meal.create!(name: 'Pizza', category: 'Fast Food', external_api_id: '12345') }

  before do
    allow(controller).to receive(:authenticate_api_v1_user!).and_return(true)
    allow(controller).to receive(:current_api_v1_user).and_return(user)
  end

  describe 'GET #index' do
    before do
      user.meal_histories.create!(meal: meal, favourite: false)
      user.meal_histories.create!(meal: meal, favourite: true)
    end

    context 'without favourite param' do
      it 'returns all meal histories' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(2)
      end
    end

    context 'with favourite param true' do
      it 'returns only favourite meal histories' do
        get :index, params: { favourite: true }, format: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(1)
        expect(json.first['favorite']).to eq(true)
      end
    end

    context 'when no history found' do
      it 'returns not found' do
        MealHistory.delete_all
        get :index, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:history) { user.meal_histories.create!(meal: meal, favourite: false) }

    it 'updates the meal history' do
      patch :update, params: { id: history.id, meal_history: { favourite: true, rating: 5 } },
                     format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['favorite']).to eq(true)
      expect(json['rating']).to eq(5)
    end

    it 'returns not found if history does not exist' do
      patch :update, params: { id: 9999, meal_history: { favourite: true } }, format: :json

      expect(response).to have_http_status(:not_found)
    end

    it 'returns error if update fails' do
      allow_any_instance_of(MealHistory).to receive(:update).and_return(false)

      patch :update, params: { id: history.id, meal_history: { favourite: nil } }, format: :json

      expect(response).to have_http_status(422)
    end
  end
end
