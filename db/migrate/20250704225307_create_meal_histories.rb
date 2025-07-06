# frozen_string_literal: true

class CreateMealHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meal, null: false, foreign_key: true
      t.timestamps
    end
  end
end
