require 'spec_helper'

describe StatuteComparisonsController do
  let(:substance) { create(:substance) }
  let(:federal_statute) { create(:federal_statute) }
  let(:state_statute) { create(:state_statute) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.confirm
    sign_in user
  end

  it 'compares across states' do
    extra_substance = SubstanceStatute.create(substance: substance, statute: federal_statute)
    get :new, compare: { state_one: federal_statute.state, state_two: state_statute.state }

    expect(assigns(:state_one_only)).to eq(federal_statute.substance_statutes.map { |ss| { difference: "Only Regulated Here", substance_statute: ss } })
    expect(assigns(:state_two_only)).to eq(state_statute.substance_statutes.map { |ss| { difference: "Only Regulated Here", substance_statute: ss } })
  end
end
