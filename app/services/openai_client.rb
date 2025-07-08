# frozen_string_literal: true

class OpenaiClient
  require "openai"

  def initialize
    @client = OpenAI::Client.new(api_key: Rails.application.credentials.openai[:api_key])
  end

  def create_user_taste_profile(preferences)
    response = client.chat.completions.create(
      messages: [
        {
          role: "system",
          content: "You are an expert food assistant. Generate a clear, short taste profile for me in English."
        },
        {
          role: "user",
          content: prompt(preferences)
        }
      ],
      model: "gpt-4o"
    )

    response.choices.first.message.content.strip
  end

  private

  attr_reader :client

  def prompt(preferences)
    <<~PROMPT
      Create a user taste profile based on my following preferences.
      Include favorite cuisines, disliked ingredients, and preferred meal types.
      Make it maximum 100 words.

      My meal history:
      #{preferences}
    PROMPT
  end
end
