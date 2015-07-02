class ScheduleLevelsController < ApplicationController
  before_action :authenticate_user!

  def show
    puts "params: #{params}"
    @substance_statutes = SubstanceStatute.where(schedule_level: params["id"]).all
    puts "#{@substance_statutes}"
  end

  def index
    @levels = {
      'I' => 1,
      'II' => 2,
      'III' => 3,
      'IV' => 4,
      'V' => 5
    }
  end

  private

  def schedule_levels_params
    params.require(:id).permit(:schedule_level)
  end
end
