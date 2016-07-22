require 'spec_helper'

describe SubstanceClassification do
  context 'include flags' do
    let(:flag) { { include_isomers: true } }
    let(:classification) { described_class.create(flag.merge(name: 'Classification')) }

    it 'should have a flag' do
      expect(classification.include_flags).to eq(flag.keys.map(&:to_s))
    end

    context 'with amendments' do
      let(:new_flag) { { include_mixtures: true } }
      let(:statute) { create(:state_statute)}
      let!(:classification_amendment) do
        ClassificationAmendment.create(new_flag.merge(name: 'Amendment', substance_classification: classification, statute: statute))
      end

      it 'should have both flags' do
        expect(classification.include_flags).to eq((flag.keys + new_flag.keys).map(&:to_s))
      end

      context 'with an as of date' do
        it 'should not find the flags before the statute date' do
          expect(classification.include_flags(as_of: statute.start_date - 1.year)).to eq((flag.keys).map(&:to_s))
        end

        it 'should find the flags after the statute date' do
          expect(classification.include_flags(as_of: statute.start_date + 1.year)).to eq((flag.keys + new_flag.keys).map(&:to_s))
        end
      end
    end
  end
end
