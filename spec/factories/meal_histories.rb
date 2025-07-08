# frozen_string_literal: true

FactoryBot.define do
  factory :meal_history do
    association :user
    association :meal

    rating { rand(1..5) }
    favourite { [true, false].sample }

    trait :with_rating do
      rating { rand(1..5) }
    end

    trait :favourite do
      favourite { true }
    end

    trait :not_favourite do
      favourite { false }
    end
  end
end
