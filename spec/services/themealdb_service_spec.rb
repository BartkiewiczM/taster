require 'rails_helper'

RSpec.describe ThemealdbService, type: :service do
  describe '.fetch_random_meal', :vcr do
    it 'returns a raw meal hash from the API' do
      meal = ThemealdbService.fetch_random_meal

      expect(meal).to be_a(Hash)
      expect(meal['idMeal']).to be_present
      expect(meal['strMeal']).to be_present
    end
  end

  describe '.random_meal', :vcr do
    it 'returns a meal when no category is given' do
      meal = ThemealdbService.random_meal
      expect(meal).to be_a(Hash)
    end

    it 'returns a meal matching the given category' do
      meal = ThemealdbService.random_meal('Dessert')
      expect(meal['strCategory']).to eq('Dessert')
    end

    it 'returns nil if no meal found after retries' do
      result = ThemealdbService.random_meal('InvalidCategory')
      expect(result).to be_nil
    end
  end
end
