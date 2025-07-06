class RemoveDescriptionFromMeals < ActiveRecord::Migration[7.1]
  def change
    remove_column :meals, :description, :text
  end
end
