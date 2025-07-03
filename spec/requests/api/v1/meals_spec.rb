require 'rails_helper'

RSpec.describe "Meals API", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/meals" do
    before do
      create_list(:meal, 3)
      get '/api/v1/meals'
    end

    it 'returns all meals' do
      expect(json.size).to eq(3)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/meals/:id" do
    let(:meal) { create(:meal) }

    before do
      get "/api/v1/meals/#{meal.id}"
    end

    it 'returns the meal' do
      expect(json['id']).to eq(meal.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/meals/random" do
    before do
      create_list(:meal, 5)
      get "/api/v1/meals/random"
    end

    it 'returns one random meal' do
      expect(json).to have_key('id')
      expect(response).to have_http_status(:ok)
    end
  end
end
