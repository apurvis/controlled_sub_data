class StatuteAmendmentSubstanceChangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @substance_change = StatuteAmendmentSubstanceChange.all
  end

  def show
    @substance_change = StatuteAmendmentSubstanceChange.where(id: params['id']).first
  end

  def edit
    @substance_change = StatuteAmendmentSubstanceChange.where(id: params['id']).first
  end

  def new
    @substance_change = StatuteAmendmentSubstanceChange.new
  end

  def create
    @substance_change = StatuteAmendmentSubstanceChange.new(substance_change_params)

    if @substance_change.save
      redirect_to @substance_change
    else
      render 'new'
    end
  end

  def update
    @substance_change = StatuteAmendmentSubstanceChange.where(id: params['id']).first

    if @substance_change.update(substance_change_params)
      redirect_to @substance_change
    else
      render 'edit'
    end
  end

  private

  def substance_change_params
    params.require(:substance_change).permit(:statute_amendment_id, :start_date, :expiration_date, :addition_or_substraction, :scheduled_level)
  end
end
