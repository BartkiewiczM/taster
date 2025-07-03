class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.string :name
      t.integer :category
      t.text :description
      t.text :ingredients
      t.text :recipe
      t.string :image_url
      t.string :external_api_id

      t.timestamps
    end
  end
end
