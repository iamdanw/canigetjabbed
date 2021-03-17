# frozen_string_literal: true

require 'dotenv/load'
require 'open-uri'
require 'twitter'

require('./lib/app/criteria_extractor')

NHS_ENGLAND_VACCINATION_SITE = 'https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/'

page = URI.parse(NHS_ENGLAND_VACCINATION_SITE).open.read

criteria = CriteriaExtractor.new(page).criteria

age_criteria = criteria.filter { |item| item.include?('age') }.first

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['API_KEY']
  config.consumer_secret     = ENV['API_KEY_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

tweet_text = "Now booking! You can now book a coronavirus vaccination appointment in England if:\n\n- #{age_criteria}"

client.update(tweet_text)

puts age_criteria
