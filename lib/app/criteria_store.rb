# frozen_string_literal: true

class DuplicateCriteriaError < StandardError
end

class HistoricalCriteria
  attr_reader :captured_at, :criteria, :additions, :deletions

  def initialize(captured_at:, criteria:, additions:, deletions:)
    @captured_at = captured_at
    @criteria = criteria
    @additions = additions
    @deletions = deletions
  end
end

class CriteriaStore
  def initialize(json)
    @history = json[:history].map do |item|
      HistoricalCriteria.new(
        captured_at: item[:captured_at],
        criteria: item[:criteria],
        additions: item[:additions],
        deletions: item[:deletions]
      )
    end
  end

  def latest
    @history.max do |a, b|
      a.captured_at <=> b.captured_at
    end
  end

  def add(new_criteria)
    raise DuplicateCriteriaError if new_criteria.sort == latest.criteria.sort

    @history.push(
      HistoricalCriteria.new(
        captured_at: Time.now.utc.to_i,
        criteria: new_criteria,
        additions: additions(latest.criteria, new_criteria),
        deletions: deletions(latest.criteria, new_criteria)
      )
    )
  end

  private

  def additions(previous_criteria, new_criteria)
    new_criteria - previous_criteria
  end

  def deletions(previous_criteria, new_criteria)
    previous_criteria - new_criteria
  end
end
