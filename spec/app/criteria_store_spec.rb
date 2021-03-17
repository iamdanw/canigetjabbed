# frozen_string_literal: true

require('app/criteria_store')
require('timecop')

RSpec.describe CriteriaStore do
  subject(:criteria_store) { described_class.new(example_json) }

  let(:example_json) do
    {
      history: [
        {
          captured_at: 1_615_531_654,
          criteria: [
            'you are aged 55 or over',
            'you are at high risk from coronavirus (clinically extremely vulnerable)',
            'you are an eligible frontline health or social care worker',
            'you have a condition that puts you at higher risk (clinically vulnerable)',
            'you have a learning disability',
            'you are a main carer for someone at high risk from coronavirus'
          ],
          additions: [
            'you are aged 55 or over',
            'you have a learning disability'
          ],
          deletions: [
            'you are aged 60 or over'
          ]
        },
        {
          captured_at: 1_615_500_000,
          criteria: [
            'you are aged 60 or over',
            'you are at high risk from coronavirus (clinically extremely vulnerable)',
            'you are an eligible frontline health or social care worker',
            'you have a condition that puts you at higher risk (clinically vulnerable)',
            'you are a main carer for someone at high risk from coronavirus'
          ],
          additions: [],
          deletions: []
        }
      ]
    }
  end

  describe '#latest' do
    it 'returns the most recently captured criteria' do
      expect(criteria_store.latest.captured_at).to eq 1_615_531_654
    end
  end

  describe '#add' do
    let(:new_criteria) do
      [
        'you are aged 40 or over',
        'you are at high risk from coronavirus (clinically extremely vulnerable)',
        'you are an eligible frontline health or social care worker',
        'you have a learning disability',
        'you are a main carer for someone at high risk from coronavirus',
        'you are in a higher risk profession'
      ]
    end
    let(:deletions) do
      [
        'you are aged 55 or over',
        'you have a condition that puts you at higher risk (clinically vulnerable)'
      ]
    end
    let(:additions) do
      [
        'you are aged 40 or over',
        'you are in a higher risk profession'
      ]
    end

    it 'stores the captured_at utc timestamp' do
      Timecop.freeze(2021, 3, 14) do
        criteria_store.add(new_criteria)
        expect(criteria_store.latest.captured_at).to eq 1_615_680_000
      end
    end

    it 'stores the criteria' do
      criteria_store.add(new_criteria)
      expect(criteria_store.latest.criteria).to match_array(new_criteria)
    end

    it 'stores the additions' do
      criteria_store.add(new_criteria)
      expect(criteria_store.latest.additions).to match_array(additions)
    end

    it 'stores the deletions' do
      criteria_store.add(new_criteria)
      expect(criteria_store.latest.deletions).to match_array(deletions)
    end

    context 'when the new criteria matches the existing latest criteria' do
      let(:duplicate_new_criteria) do
        [
          'you are aged 55 or over',
          'you are at high risk from coronavirus (clinically extremely vulnerable)',
          'you are an eligible frontline health or social care worker',
          'you have a condition that puts you at higher risk (clinically vulnerable)',
          'you have a learning disability',
          'you are a main carer for someone at high risk from coronavirus'
        ]
      end

      it 'raises an error' do
        expect { criteria_store.add(duplicate_new_criteria) }.to raise_error(DuplicateCriteriaError)
      end
    end
  end
end
