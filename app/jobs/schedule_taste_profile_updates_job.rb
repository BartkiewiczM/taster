# frozen_string_literal: true

class ScheduleTasteProfileUpdatesJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      UpdateTasteProfileJob.perform_later(user.id)
    end
  end
end
