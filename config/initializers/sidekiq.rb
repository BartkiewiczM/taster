# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }

  schedule = {
    'schedule_taste_profile_updates' => {
      'class' => 'ScheduleTasteProfileUpdatesJob',
      'cron' => '*/5 * * * *',
      'queue' => 'default'
    }
  }

  Sidekiq::Cron::Job.load_from_hash schedule
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }
end
