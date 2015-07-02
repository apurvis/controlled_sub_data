class SubstanceStatutesController < ApplicationController
  before_action :authenticate_user!

  def show
    @substance_statute = SubstanceStatute.where(id: params["id"]).first
  end

  def index
    @substance_statutes = SubstanceStatute.all
  end

  def new
    @substance_statute = SubstanceStatute.new
  end

  def create
    render plain: params[:substance_statute].inspect
  end

  private

  def substance_statutes_params
    params.require(:substance_statute).permit(:substance, :statute, :schedule_level)
  end
end
