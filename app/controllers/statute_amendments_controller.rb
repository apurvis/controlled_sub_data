class StatuteAmendmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @statute_amendments = StatuteAmendment.all
  end

  def show
    @statute_amendment = StatuteAmendment.where(id: params['id']).first
  end

  def edit
    @statute_amendment = StatuteAmendment.where(id: params['id']).first
  end

  def new
    @statute = Statute.where(id: params['statute_amendment']['parent_id']).first
    @statute_amendment = StatuteAmendment.new(parent_id: @statute.id, state: @statute.state)
  end

  def create
    @statute = Statute.where(id: params['statute_amendment']['parent_id']).first
    @statute_amendment = StatuteAmendment.new(statute_amendment_params.merge(state: @statute.state))

    if @statute_amendment.save
      redirect_to @statute_amendment
    else
      render 'new'
    end
  end

  def update
    @statute_amendment = StatuteAmendment.where(id: params['id']).first

    if @statute_amendment.update(statute_amendment_params)
      redirect_to @statute_amendment
    else
      render 'edit'
    end
  end

  private

  def statute_amendment_params
    params.require(:statute_amendment).permit(:statute_id, :parent_id, :state, :start_date, :expiration_date)
  end
end
