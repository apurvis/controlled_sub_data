require 'spec_helper'

describe Statute do
  let!(:federal_statute) { create(:federal_statute) }
  let(:inheritance_date) { '2000-01-01'.to_date }
  let!(:inheriting_statute) { create(:state_statute, start_date: inheritance_date, duplicate_federal_as_of_date: inheritance_date) }

  it 'should find the inherited statute' do
    expect(inheriting_statute.duplicated_federal_statutes).to eq([federal_statute])
    expect(inheriting_statute.duplicated_federal_substance_statutes.size).to eq(1)
  end

  context 'substance_statutes' do
    it 'should find duplicated substance_statutes' do
      expect(inheriting_statute.duplicated_federal_substance_statutes).to eq(federal_statute.substance_statutes)
    end

    context 'expired on federal' do
      let(:federal_amendment) { StatuteAmendment.new(state: federal_statute.state, start_date: inheritance_date - 1.year, parent_id: federal_statute.id) }
      let!(:expiration) { SubstanceStatute.create(statute: federal_amendment, substance: federal_statute.substance_statutes.first.substance, is_expiration: true) }

      it 'should exclude regulations that have expired on the federal statue' do
        expect(inheriting_statute.duplicated_federal_substance_statutes).to eq([])
      end

      it 'should still find them if they expired after the cutoff' do
        federal_amendment.start_date = inheritance_date + 1.year
        federal_amendment.save
        expect(inheriting_statute.duplicated_federal_substance_statutes(as_of: inheritance_date)).to eq([federal_statute.substance_statutes.first])
      end
    end

    it 'should exclude regulations that have expired in the local amendments' do
    end

    it 'should include expired statutes if looking before their expiration date' do
    end
  end
end
