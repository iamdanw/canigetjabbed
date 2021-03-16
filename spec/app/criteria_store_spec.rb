# frozen_string_literal: true

require('app/criteria_store')
require('timecop')

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

  describe '#add' do
    let(:new_criteria) {
      [
        "you are aged 40 or over",
        "you are at high risk from coronavirus (clinically extremely vulnerable)",
        "you are an eligible frontline health or social care worker",
        "you have a condition that puts you at higher risk (clinically vulnerable)",
        "you have a learning disability",
        "you are a main carer for someone at high risk from coronavirus",
        "you are in a higher risk profession"
      ]
    }

    it 'stores the captured_at utc timestamp' do
      Timecop.freeze(2021, 3, 14) do
        subject.add(new_criteria)
        expect(subject.latest[:captured_at]).to eq 1615680000
      end
    end

    it 'stores the criteria' do
      subject.add(new_criteria)
      expect(subject.latest[:criteria]).to match_array(new_criteria)
    end
  end
end
