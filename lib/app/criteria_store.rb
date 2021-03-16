# frozen_string_literal: true


class CriteriaStore
  def initialize(json)
    @json = json
  end

  def latest
    @json[:history].sort{ |a, b|
      a[:captured_at] <=> b[:captured_at]
    }.last
  end

  def add(new_criteria)
    @json[:history].push({
      captured_at: Time.now.utc.to_i,
      criteria: new_criteria
    })
  end
end
