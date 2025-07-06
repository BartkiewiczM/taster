# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :meal_histories, dependent: :destroy
  has_many :meals, through: :meal_histories

  validates :email, presence: true, uniqueness: true
end
