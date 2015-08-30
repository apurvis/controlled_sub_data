require 'spec_helper'

describe StatuteSearchesController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.confirm!
    sign_in user
  end

  it 'dew' do
  end
end
