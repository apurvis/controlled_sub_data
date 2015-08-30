require 'spec_helper'

describe StatutesController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.confirm!
    sign_in user
  end

  it 'dew' do
    substance = create(:substance)
    federal_statute = create(:federal_statute)
    SubstanceStatute.create(substance: substance, statute: federal_statute)
    get :index, search: { substance_id: substance.id }
    expect(assigns(:statutes)).to eq([federal_statute])
  end
end