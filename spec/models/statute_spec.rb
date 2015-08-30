require 'spec_helper'

describe Statute do
  let(:inheritance_date) { '2000-01-01'.to_date }
  let(:inheriting_statute) { Statute.new(state: 'NY', name: 'NY Law', start_date: inheritance_date, duplicate_federal_as_of_date: inheritance_date) }

  it 'should find the inherited statute' do
    federal_statute = create(:federal_statute)
    expect(inheriting_statute.duplicated_federal_statutes).to eq([federal_statute])
    expect(inheriting_statute.duplicated_federal_substance_statutes.size).to eq(1)
  end
end
