class StatuteAmendmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @statute_amendments = StatuteAmendment.all
  end
end
