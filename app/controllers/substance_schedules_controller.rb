class SubstanceSchedulesController < ApplicationController
  before_action :authenticate_user!

  def show
    @substance_schedules = SubstanceSchedule.where(id: params["id"]).first
  end

  def index
    @substance_schedules = SubstanceSchedule.all
  end

  def new
    @substance_schedules = SubstanceSchedule.new
  end

  def create
    render plain: params[:substance_schedule].inspect
  end

  private

  def substance_schedules_params
    params.require(:substance_schedule).permit(:substance, :schedule, :schedule_level)
  end
end
