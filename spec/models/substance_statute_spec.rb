require 'spec_helper'

describe SubstanceStatute do
  context 'regulates_same_as?' do
    let(:federal_statute) { create(:federal_statute) }
    let(:federal_first_regulation) { federal_statute.substance_statutes.first }
    let(:state_statute) { create(:state_statute) }
    let(:state_first_regulation) { state_statute.substance_statutes.first }
    let(:matching_regulation) { SubstanceStatute.new(statute: state_statute, substance: federal_first_regulation.substance) }

    it 'identifies basic matches' do
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([])
      expect(matching_regulation.regulation_differences(federal_first_regulation)).to eq([])
    end

    it 'identifies substance level mismatches' do
      expect(federal_first_regulation.regulation_differences(state_first_regulation)).to eq([SubstanceStatute::DIFFERENT_SUBSTANCES])
    end

    it 'identifies schedule level mismatches' do
      federal_first_regulation.schedule_level = 5
      matching_regulation.schedule_level = 1
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([SubstanceStatute::DIFFERENT_SCHEDULE])
    end

    it 'identifies salt and isomer mismatches' do
      matching_regulation.include_salts = true
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([SubstanceStatute::DIFFERENT_SALTS])
    end

    it 'can identify multiple levels of mismatch' do
      federal_first_regulation.schedule_level = 5
      matching_regulation.include_salts = true
      matching_regulation.schedule_level = 3
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([SubstanceStatute::DIFFERENT_SALTS, SubstanceStatute::DIFFERENT_SCHEDULE])
    end
  end
end
