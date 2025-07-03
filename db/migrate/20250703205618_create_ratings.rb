class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meal, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment

      t.timestamps
    end

    add_index :ratings, [:user_id, :meal_id], unique: true
  end
end
