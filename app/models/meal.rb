class Meal < ApplicationRecord
  enum category: { breakfast: 0, lunch: 1, dinner: 2, dessert: 3 }

  validates :name, :category, presence: true

  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
