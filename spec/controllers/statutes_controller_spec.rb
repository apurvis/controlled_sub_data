require 'spec_helper'

describe StatutesController do
  let(:substance) { create(:substance) }
  let(:federal_statute) { create(:federal_statute) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.confirm
    sign_in user

    SubstanceStatute.create(substance: substance, statute: federal_statute)
  end

  it 'searches by substance' do
    get :index, search: { substance_id: substance.id }
    expect(assigns(:statutes)).to eq([federal_statute])
  end

  it 'searches by state' do
    get :index, search: { state: Statute::FEDERAL }
    expect(response).to redirect_to(statute_path(federal_statute))
  end
end
