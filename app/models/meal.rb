# frozen_string_literal: true

class Meal < ApplicationRecord
  validates :name, :category, :external_api_id, presence: true

  has_many :meal_histories, dependent: :destroy
  has_many :users, through: :meal_histories
end
