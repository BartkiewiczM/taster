# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production, # rubocop:disable Layout/LineLength
# development, test). The code here should be idempotent so that it can be executed at any point in every environment. # rubocop:disable Layout/LineLength
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup). # rubocop:disable Layout/LineLength
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
