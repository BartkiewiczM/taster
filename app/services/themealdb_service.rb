# frozen_string_literal: true

class ThemealdbService
  API_BASE = 'https://www.themealdb.com/api/json/v1/1'

  def self.random_meal(category = nil)
    return fetch_random_meal if category.blank?

    15.times do # retry max 15 times to find a matching category not to overwhelm the API
      meal = fetch_random_meal
      return meal if meal['strCategory'].casecmp(category).zero?
    end

    nil # returns nil if no match after retries
  end

  def self.fetch_random_meal
    response = Faraday.get("#{API_BASE}/random.php")
    JSON.parse(response.body)['meals'].first
  end
end
