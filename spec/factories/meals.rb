# frozen_string_literal: true

FactoryBot.define do
  factory :meal do
    name { Faker::Food.dish }
    ingredients { Faker::Food.ingredient }
    recipe { Faker::Lorem.paragraph }
    image_url { Faker::Internet.url }
    external_api_id { SecureRandom.uuid }
  end
end
