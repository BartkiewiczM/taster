# frozen_string_literal: true

class UpdateTasteProfileJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    preferences = UserPreferences.new(user).fetch
    checksum = Digest::SHA256.hexdigest(preferences)

    cached_checksum = Rails.cache.read("user:#{user.id}:preferences_checksum")

    return if checksum == cached_checksum

    taste_profile = OpenaiClient.new.create_user_taste_profile(preferences)
    user.update!(preferences: taste_profile)

    Rails.cache.write("user:#{user.id}:preferences_checksum", checksum)
  end
end
