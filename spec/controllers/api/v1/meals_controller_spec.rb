require 'rails_helper'

RSpec.describe Api::V1::MealsController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  describe 'GET #random' do
    context 'when service returns a meal' do
      let(:mock_meal) do
        {
          'idMeal' => '123',
          'strMeal' => 'Test Meal',
          'strCategory' => 'Dessert',
          'strInstructions' => 'Do something',
          'strMealThumb' => 'http://example.com/image.jpg'
        }
      end

      before do
        sign_in user
        allow(ThemealdbService).to receive(:random_meal).and_return(mock_meal)
      end

      it 'returns ok and formatted meal' do
        get :random
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body['id']).to eq('123')
        expect(body['name']).to eq('Test Meal')
      end
    end

    context 'when service returns nil' do
      before do
        sign_in user
        allow(ThemealdbService).to receive(:random_meal).and_return(nil)
      end

      it 'returns not found' do
        get :random, params: { category: 'InvalidCategory' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Meal not found in category' })
      end
    end
  end
end
