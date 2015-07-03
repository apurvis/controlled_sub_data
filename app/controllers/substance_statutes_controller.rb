class SubstanceStatutesController < ApplicationController
  before_action :authenticate_user!

  def show
    @substance_statute = SubstanceStatute.where(id: params['id']).first
  end

  def edit
    @substance_statute = SubstanceStatute.where(id: params['id']).first
  end

  def index
    @substance_statutes = SubstanceStatute.all
  end

  def new
    @substance_statute = SubstanceStatute.new
  end

  def create
    @substance_statute = SubstanceStatute.new(substance_statutes_params)

    if @substance_statute.save
      redirect_to @substance_statute
    else
      render 'new'
    end
  end

  def update
    @substance_statute = SubstanceStatute.where(id: params['id']).first

    if @substance_statute.update(substance_statutes_params)
      redirect_to @substance_statute
    else
      render 'edit'
    end
  end

  private

  def substance_statutes_params
    params.require(:substance_statute).permit(:substance_id, :statute_id, :schedule_level)
  end
end
