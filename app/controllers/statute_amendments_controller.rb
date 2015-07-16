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
    @statute_amendment = StatuteAmendment.new
  end

  def create
    @statute_amendment = StatuteAmendment.new(statute_amendment_params)

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
    params.require(:statute_amendment).permit(:statute_id, :start_date, :expiration_date)
  end
end
