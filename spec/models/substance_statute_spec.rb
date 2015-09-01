require 'spec_helper'

describe SubstanceStatute do
  let(:federal_statute) { create(:federal_statute) }
  let(:federal_first_regulation) { federal_statute.substance_statutes.first }
  let(:state_statute) { create(:state_statute) }
  let(:state_first_regulation) { state_statute.substance_statutes.first }

  context 'regulates_same_as?' do
    let(:matching_regulation) { described_class.new(statute: state_statute, substance: federal_first_regulation.substance) }

    it 'identifies basic matches' do
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([])
      expect(matching_regulation.regulation_differences(federal_first_regulation)).to eq([])
    end

    it 'identifies substance level mismatches' do
      expect(federal_first_regulation.regulation_differences(state_first_regulation)).to eq([described_class::DIFFERENT_SUBSTANCES])
    end

    it 'identifies schedule level mismatches' do
      federal_first_regulation.schedule_level = 5
      matching_regulation.schedule_level = 1
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SCHEDULE])
    end

    it 'identifies salt and isomer mismatches' do
      matching_regulation.include_salts = true
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SALTS])
    end

    it 'can identify multiple levels of mismatch' do
      federal_first_regulation.schedule_level = 5
      matching_regulation.include_salts = true
      matching_regulation.schedule_level = 3
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SALTS, described_class::DIFFERENT_SCHEDULE])
    end
  end

  context 'expirations' do
    let(:expiration_date) { '2000-05-01'.to_date }
    let(:expiring_statute) do
      StatuteAmendment.create(state: Statute::FEDERAL, parent_id: federal_statute.id, start_date: expiration_date).tap do |s|
        expiration = described_class.create(substance_id: federal_first_regulation.substance.id, statute_id: s.id, is_expiration: true)
        s
      end
    end

    it 'should find the expiration' do
      expiring_statute.save
      expect(federal_first_regulation.expiring_amendment).to eq(expiring_statute)
    end

    it 'should not find the expiration if date limited' do
      expiring_statute.save
      expect(federal_first_regulation.expiring_amendment(expiration_date - 100.days)).to be_nil
    end

    context 'duplicated federal statutes' do
      let(:duplicated_statute) do
        Statute.create(duplicate_federal_as_of_date: expiration_date - 1.year, parent_id: federal_statute.id, start_date: expiration_date)
      end

      it 'should not find the expiration if it expired in a different state' do

      end

      it 'should find the expiration if duped federal then expired' do
      end
    end
  end
end
