require 'spec_helper'

describe SubstanceStatute do
  let(:federal_statute) { create(:federal_statute) }
  let(:federal_first_regulation) { federal_statute.substance_statutes.first }
  let(:state_statute) { create(:state_statute) }
  let(:state_first_regulation) { state_statute.substance_statutes.first }

  context 'comparisons' do
    let(:matching_regulation) { described_class.new(statute: state_statute, substance: federal_first_regulation.substance) }

    it 'finds no differences when the substances are the same' do
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([])
      expect(matching_regulation.regulation_differences(federal_first_regulation)).to eq([])
    end

    it 'identifies substance level mismatches' do
      expect(federal_first_regulation.regulation_differences(state_first_regulation)).to eq([described_class::DIFFERENT_SUBSTANCES])
    end

    context 'salt and isomer changes' do
      context 'direct comparison' do
        it 'identifies direct salt and isomer mismatches' do
          matching_regulation.include_salts = true
          expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([])
          expect(matching_regulation.regulation_differences(federal_first_regulation)).to eq([described_class::DIFFERENT_SALTS])
        end
      end

      context 'with classifications' do
        let(:classification) { SubstanceClassification.create(name: 'opiates', include_salts: true) }

        before do
          matching_regulation.substance_classification = classification
          matching_regulation.save
        end

        it 'identifies salt and isomer mismatches from classifications' do
          expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([])
          expect(matching_regulation.regulation_differences(federal_first_regulation)).to eq([described_class::DIFFERENT_SALTS])
        end

        context 'with an as_of time' do
          it 'excludes salt and isomers when the classification has no statute and as_of is provided' do
            expect(federal_first_regulation.regulation_differences(matching_regulation, as_of: Date.today)).to eq([])
          end

          it 'identifies salt and isomer mismatches from classifications with an as of date' do
            amendment = StatuteAmendment.create(statute: federal_statute, start_date: federal_statute.start_date + 1.day)
            classification.statute = amendment
            classification.save
            expect(matching_regulation.regulation_differences(federal_first_regulation, as_of: Date.today)).to eq([described_class::DIFFERENT_SALTS])
          end
        end
      end
    end
  end

  context 'first_matching_alternate_name' do
    let(:name) { 'some_euro_thing'}
    let!(:state_fan) { SubstanceAlternateName.create(substance_statute: state_first_regulation, name: name) }

    it 'should find no alternate name matches' do
      expect(state_first_regulation.first_matching_alternate_name(federal_first_regulation)).to be_nil
    end

    context 'with alternate name matches' do
      let!(:federal_san) { SubstanceAlternateName.create(substance_statute: federal_first_regulation, name: name) }

      it 'notices they regulate the same name' do
        expect(state_first_regulation.first_matching_alternate_name(federal_first_regulation)).to eq(federal_san)
      end
    end

    context 'with an actual substance match' do
      let(:new_substance) { create(:substance, name: name) }

      it 'finds the substance with the matching name' do
        federal_first_regulation.substance = new_substance
        expect(state_first_regulation.first_matching_alternate_name(federal_first_regulation)).to eq(new_substance)
      end
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
      expect(federal_first_regulation.expiring_amendment(as_of: expiration_date - 100.days)).to be_nil
    end

    context 'duplicated federal statutes' do
      let(:duplicated_statute) do
        Statute.create(duplicate_federal_as_of_date: expiration_date - 1.year, parent_id: federal_statute.id, start_date: expiration_date)
      end

      it 'should not find the expiration if it expired in a different state'
      it 'should find the expiration if duped federal then expired'
    end
  end

  context 'include flags' do
    let(:flag) { { include_isomers: true } }

    it 'without a classificatino it should not have any inherited flags' do
      expect(federal_first_regulation.include_flags).to be_empty
    end

    context 'with a classification' do
      let(:substance_classification) { SubstanceClassification.create(flag.merge(name: 'Classification')) }
      before do
        federal_first_regulation.substance_classification = substance_classification
      end

      it 'should inherit flags from a classification' do
        expect(federal_first_regulation.include_flags).to eq([flag.keys.first.to_s])
      end
    end
  end
end
