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
        criteria: new_criteria
      }
    )
  end
end
