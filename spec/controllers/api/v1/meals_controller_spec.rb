# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MealsController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  describe 'GET #random' do
    let(:mock_meal_data) do
      {
        'idMeal' => '123',
        'strMeal' => 'Test Meal',
        'strCategory' => 'Dessert',
        'strInstructions' => 'Do something',
        'strMealThumb' => 'http://example.com/image.jpg'
      }
    end

    let(:persisted_meal) do
      Meal.create!(
        external_api_id: '123',
        name: 'Test Meal',
        category: 'Dessert',
        recipe: 'Do something',
        ingredients: 'Ingredient - 1',
        image_url: 'http://example.com/image.jpg'
      )
    end

    before do
      sign_in user
    end

    context 'when service returns a meal' do
      before do
        allow(ThemealdbService).to receive(:random_meal).and_return(mock_meal_data)
        allow(PersistMeal).to receive(:call).and_return(persisted_meal)
      end

      it 'returns ok, persists meal and saves it to user history' do
        get :random

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['id']).to eq('123')
        expect(body['name']).to eq('Test Meal')

        expect(PersistMeal).to have_received(:call).with(mock_meal_data)
        expect(user.meals).to include(persisted_meal)
      end
    end

    context 'when the meal is already in the user history' do
      before do
        user.meals << persisted_meal

        allow(ThemealdbService).to receive(:random_meal).and_return(mock_meal_data)
        allow(PersistMeal).to receive(:call).and_return(persisted_meal)
      end

      it 'does not duplicate the meal in user history (checks by external_api_id)' do
        expect {
          get :random
        }.not_to change { user.meals.count }

        expect(response).to have_http_status(:ok)
        expect(user.meals).to include(persisted_meal)
      end
    end

    context 'when service returns nil' do
      before do
        allow(ThemealdbService).to receive(:random_meal).and_return(nil)
      end

      it 'returns not found' do
        get :random, params: { category: 'InvalidCategory' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Meal not found in category' })
      end
    end
  end

  describe 'GET #show' do
    let!(:meal) do
      Meal.create!(
        external_api_id: '999',
        name: 'Saved Meal',
        category: 'Pasta',
        recipe: 'Cook it well.',
        ingredients: "Pasta - 200g\nTomato - 1",
        image_url: 'http://example.com/saved.jpg'
      )
    end

    before { sign_in user }

    it 'returns the saved meal by external_api_id' do
      get :show, params: { id: '999' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Saved Meal')
      expect(json['category']).to eq('Pasta')
      expect(json['ingredients']).to include('Pasta - 200g')
    end

    it 'returns 404 if meal not found' do
      get :show, params: { id: 'nonexistent' }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Meal not found' })
    end
  end
end
