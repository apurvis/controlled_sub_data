require 'spec_helper'

describe Statute do
  let!(:federal_statute) { create(:federal_statute) }
  let(:inheritance_date) { '2000-01-01'.to_date }
  let!(:inheriting_statute) { create(:state_statute, start_date: inheritance_date, duplicate_federal_as_of_date: inheritance_date) }

  it 'should find the inherited statute' do
    expect(inheriting_statute.duplicated_federal_statutes).to eq([federal_statute])
    expect(inheriting_statute.duplicated_federal_substance_statutes.size).to eq(1)
  end

  context 'duplicated federal' do
    it 'should find duplicated substance_statutes' do
      expect(inheriting_statute.duplicated_federal_substance_statutes).to eq(federal_statute.substance_statutes)
    end

    context 'expired on federal' do
      let(:federal_amendment) { StatuteAmendment.create(state: federal_statute.state, start_date: inheritance_date - 1.year, parent_id: federal_statute.id) }
      let!(:expiration) { SubstanceStatute.create(statute: federal_amendment, substance: federal_statute.substance_statutes.first.substance, is_expiration: true) }

      it 'should include both additions and expirations' do
        expect(inheriting_statute.duplicated_federal_substance_statutes).to eq([federal_statute.substance_statutes.first, expiration])
      end

      it 'should find them if they expired after the request cutoff or after duplication date' do
        federal_amendment.start_date = inheritance_date + 1.year
        federal_amendment.save
        expect(inheriting_statute.duplicated_federal_substance_statutes(as_of: inheritance_date)).to eq([federal_statute.substance_statutes.first])
        expect(inheriting_statute.duplicated_federal_substance_statutes).to eq([federal_statute.substance_statutes.first])
      end
    end

    context 'effective regulations as of date' do
      let(:state_amendment) { StatuteAmendment.create(state: inheriting_statute.state, start_date: inheritance_date + 1.year, parent_id: inheriting_statute.id) }

      context 'amendment additions' do
        let!(:addition) { SubstanceStatute.create(statute: state_amendment, substance: create(:substance)) }

        it 'should find the inherited and amended regulations' do
          expect(inheriting_statute.effective_substance_statutes).to eq(federal_statute.substance_statutes + inheriting_statute.substance_statutes + state_amendment.substance_statutes)
        end

        context 'that are just property changes' do
          it 'seems to work right now but no spec'
        end

        context 'for an expired amendment' do
          let(:expiration_date) { inheritance_date + 2.years }
          before do
            state_amendment.expiration_date = expiration_date
            state_amendment.save
          end

          it 'should NOT find the amended regulations as of now' do
            expect(inheriting_statute.effective_substance_statutes).to eq(federal_statute.substance_statutes + inheriting_statute.substance_statutes)
          end

          it 'should find the amended regulations before the expiration date' do
            expect(inheriting_statute.effective_substance_statutes(as_of: expiration_date - 10.days)).to eq(federal_statute.substance_statutes + inheriting_statute.substance_statutes + state_amendment.substance_statutes)
          end
        end
      end

      context 'with explicit expirations' do
        let!(:expiration) { SubstanceStatute.create(statute: state_amendment, substance: federal_statute.substance_statutes.first.substance, is_expiration: true) }

        it 'should exclude regulations that have expired in the local amendments' do
          expect(inheriting_statute.effective_substance_statutes).to eq([inheriting_statute.substance_statutes.first])
        end

        it 'should include expired statutes if looking before their expiration date' do
          expect(inheriting_statute.effective_substance_statutes(as_of: inheritance_date)).to eq([federal_statute.substance_statutes.first, inheriting_statute.substance_statutes.first])
        end
      end
    end
  end
end
