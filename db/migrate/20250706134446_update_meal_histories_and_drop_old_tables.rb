# frozen_string_literal: true

class UpdateMealHistoriesAndDropOldTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :favorites
    drop_table :ratings

    add_column :meal_histories, :favourite, :boolean, default: false, null: false
    add_column :meal_histories, :rating, :integer
  end
end
