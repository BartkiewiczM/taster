# frozen_string_literal: true

class CustomFailureApp < Devise::FailureApp
  def respond
    json_api_error_response
  end

  def json_api_error_response
    self.status = :unauthorized
    self.content_type = 'application/json'
    self.response_body = { error: i18n_message }.to_json
  end
end
