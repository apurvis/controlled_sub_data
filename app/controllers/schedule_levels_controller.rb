class ScheduleLevelsController < ApplicationController
  before_action :authenticate_user!

  LEVELS = {
    'I'   => 1,
    'II'  => 2,
    'III' => 3,
    'IV'  => 4,
    'V'   => 5,
    'VI'  => 6
  }

  def show
    @level = params['id'].to_i
    @roman_level = ScheduleLevelsController::LEVELS.keys[@level - 1]
    @substances = SubstanceStatute.where(schedule_level: @level).map { |ss| ss.substance }
    @classifications = SubstanceClassification.where(schedule_level: @level).order(name: :asc)
  end

  def index
    @levels = LEVELS
  end

  private

  def schedule_levels_params
    params.require(:id).permit(:schedule_level)
  end
end
