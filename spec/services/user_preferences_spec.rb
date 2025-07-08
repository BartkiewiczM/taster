# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPreferences, type: :service do
  describe '#fetch' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }
    let(:meal) { create(:meal, name: 'Pizza', category: 'Italian', ingredients: 'cheese, tomato') }

    before do
      create(:meal_history, user: user, meal: meal, rating: 5, favourite: true)
      create(:meal_history, user: user, meal: meal, rating: nil, favourite: false)
    end

    it 'returns formatted preferences only for rated or favourite meals' do
      prefs = described_class.new(user).fetch

      expect(prefs).to include('Meal: Pizza')
      expect(prefs).to include('Rating: 5')
      expect(prefs).to include('Favourite: true')
    end
  end
end
