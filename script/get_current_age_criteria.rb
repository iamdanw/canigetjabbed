# frozen_string_literal: true

require 'open-uri'

require('./lib/app/criteria_extractor')

NHS_ENGLAND_VACCINATION_SITE = 'https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/'

page = URI.parse(NHS_ENGLAND_VACCINATION_SITE).open.read

criteria = CriteriaExtractor.new(page).criteria

age_criteria = criteria.filter { |item| item.include?('age') }.first

puts age_criteria
