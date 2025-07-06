# frozen_string_literal: true

class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.integer :category, null: false, default: 0
      t.text :description
      t.text :ingredients
      t.text :recipe
      t.string :image_url
      t.string :external_api_id

      t.timestamps
    end

    add_index :meals, :external_api_id, unique: true
  end
end
