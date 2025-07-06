# frozen_string_literal: true

class MealHistory < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  validates :user_id, :meal_id, presence: true
end
