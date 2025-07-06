# frozen_string_literal: true

class ChangeMealCategoryToString < ActiveRecord::Migration[7.1]
  def change
    change_column :meals, :category, :string
  end
end
