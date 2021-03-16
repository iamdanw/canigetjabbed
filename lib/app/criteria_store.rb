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
end
