# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleTasteProfileUpdatesJob, type: :job do
  before { ActiveJob::Base.queue_adapter = :test }

  let!(:user1) { User.create!(email: 'user1@example.com', password: 'password') }
  let!(:user2) { User.create!(email: 'user2@example.com', password: 'password') }

  it 'enqueues UpdateTasteProfileJob for each user' do
    expect {
      described_class.perform_now
    }.to have_enqueued_job(UpdateTasteProfileJob).with(user1.id)
                                                 .and have_enqueued_job(UpdateTasteProfileJob)
                                                 .with(user2.id)
  end
end
