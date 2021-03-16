# frozen_string_literal: true

require('app/criteria_store')

RSpec.describe CriteriaStore do
  let(:example_json) {
    {
      history: [
        {
          captured_at: 1615531654,
          criteria: [
            "you are aged 55 or over",
            "you are at high risk from coronavirus (clinically extremely vulnerable)",
            "you are an eligible frontline health or social care worker",
            "you have a condition that puts you at higher risk (clinically vulnerable)",
            "you have a learning disability",
            "you are a main carer for someone at high risk from coronavirus"
          ]
        },
        {
          captured_at: 1615500000,
          criteria: [
            "you are aged 60 or over",
            "you are at high risk from coronavirus (clinically extremely vulnerable)",
            "you are an eligible frontline health or social care worker",
            "you have a condition that puts you at higher risk (clinically vulnerable)",
            "you are a main carer for someone at high risk from coronavirus"
          ]
        }
      ]
    }
  }
  subject(:criteria_store) { described_class.new(example_json) }

  describe '#latest' do
    it 'returns the most recently captured criteria' do
      expect(subject.latest[:captured_at]).to eq 1615531654
    end
  end
end
