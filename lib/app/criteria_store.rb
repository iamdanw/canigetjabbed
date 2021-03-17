# frozen_string_literal: true

class DuplicateCriteriaError < StandardError
end

class CriteriaStore
  def initialize(json)
    @json = json
  end

  def latest
    @json[:history].max do |a, b|
      a[:captured_at] <=> b[:captured_at]
    end
  end

  def add(new_criteria)
    raise DuplicateCriteriaError if new_criteria.sort == latest[:criteria].sort

    @json[:history].push(
      {
        captured_at: Time.now.utc.to_i,
        criteria: new_criteria,
        additions: additions(latest[:criteria], new_criteria),
        deletions: deletions(latest[:criteria], new_criteria)
      }
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
