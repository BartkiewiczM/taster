# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenaiClient, type: :service do
  describe '#create_user_taste_profile', :vcr do
    it 'returns a taste profile as a string' do
      preferences = "- Meal: Pizza, Category: Italian, Ingredients: cheese, tomato, Rating: 5, Favourite: true" # rubocop:disable Layout/LineLength
      client = OpenaiClient.new

      result = client.create_user_taste_profile(preferences)

      expect(result).to be_a(String)
      expect(result).not_to be_empty
      expect(result.length).to be > 10
    end
  end

  describe '#prompt' do
    it 'builds a prompt with the preferences' do
      preferences = "Pizza, Pasta"
      client = OpenaiClient.new

      prompt = client.send(:prompt, preferences)

      expect(prompt).to include(preferences)
      expect(prompt).to include('Create a user taste profile')
    end
  end
end
