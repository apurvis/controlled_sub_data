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

    context 'salt and isomer changes' do
      context 'direct comparison' do
        it 'identifies direct salt and isomer mismatches' do
          matching_regulation.include_salts = true
          expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SALTS])
        end
      end

      context 'with classifications' do
        let(:classification) { SubstanceClassification.create(name: 'opiates', include_salts: true) }

        before do
          matching_regulation.substance_classification_id = classification.id
          matching_regulation.save
        end

        it 'identifies salt and isomer mismatches from classifications' do
          expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SALTS])
        end

        context 'with an as_of time' do
          it 'excludes salt and isomers when the classification has no statute and as_of is provided' do
            expect(federal_first_regulation.regulation_differences(matching_regulation, as_of: Date.today)).to eq([])
          end

          it 'identifies salt and isomer mismatches from classifications with an as of date' do
            amendment = StatuteAmendment.create(parent_id: federal_statute.id, start_date: federal_statute.start_date + 1.day)
            classification.statute_id = amendment.id
            classification.save
            expect(federal_first_regulation.regulation_differences(matching_regulation, as_of: Date.today)).to eq([described_class::DIFFERENT_SALTS])
          end
        end
      end
    end

    it 'can identify multiple levels of mismatch' do
      federal_first_regulation.schedule_level = 5
      matching_regulation.include_salts = true
      matching_regulation.schedule_level = 3
      expect(federal_first_regulation.regulation_differences(matching_regulation)).to eq([described_class::DIFFERENT_SALTS])
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

      it 'should not find the expiration if it expired in a different state' do

      end

      it 'should find the expiration if duped federal then expired' do
      end
    end
  end

  context 'include flags' do
    let(:flag) { { include_isomers: true } }
    let(:substance_classification) { SubstanceClassification.create(flag.merge(name: 'Classification')) }

    it 'should not have any inherited flags' do
      expect(federal_first_regulation.include_flags).to be_empty
    end

    it 'should inherit flags' do
      federal_first_regulation.substance_classification_id = substance_classification.id
      federal_first_regulation.save
      expect(federal_first_regulation.include_flags).to eq([flag.keys.first.to_s])
    end
  end
end
