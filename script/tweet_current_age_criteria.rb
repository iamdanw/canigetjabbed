# frozen_string_literal: true

require 'dotenv/load'
require 'twitter'

age_criteria = ARGV[0]

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['API_KEY']
  config.consumer_secret     = ENV['API_KEY_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

tweet_text = "Now booking! You can now book a coronavirus vaccination appointment in England if:\n\n- #{age_criteria}"

client.update(tweet_text)

puts 'I just tweeted it out:'
puts tweet_text
