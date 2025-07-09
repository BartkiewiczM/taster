# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateTasteProfileJob, type: :job do
  let(:user) { User.create!(email: "test@example.com", password: "password") }

  before do
    allow_any_instance_of(UserPreferences).to receive(:fetch).and_return("test preferences")
    allow_any_instance_of(OpenaiClient).to receive(:create_user_taste_profile)
      .and_return("New taste profile")
  end

  it "updates taste profile if checksum changed" do
    expect(user.preferences).to be_nil

    described_class.perform_now(user.id)

    user.reload
    expect(user.preferences).to eq("New taste profile")

    checksum = Digest::SHA256.hexdigest("test preferences")
    expect(Rails.cache.read("user:#{user.id}:preferences_checksum")).to eq(checksum)
  end

  it "does not update taste profile if checksum matches" do
    checksum = Digest::SHA256.hexdigest("test preferences")
    Rails.cache.write("user:#{user.id}:preferences_checksum", checksum)

    user.update!(preferences: "Old taste profile")

    described_class.perform_now(user.id)

    user.reload
    expect(user.preferences).to eq("Old taste profile")
  end
end
