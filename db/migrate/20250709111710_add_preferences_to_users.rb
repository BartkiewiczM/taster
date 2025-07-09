# frozen_string_literal: true

class AddPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :preferences, :text
  end
end
