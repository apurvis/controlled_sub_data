class ScheduleLevelsController < ApplicationController
  before_action :authenticate_user!

  def show
    @level = params['id'].to_i
    @roman_level = RomanScheduleLevel::LEVELS.keys[@level - 1]
    @substances = SubstanceStatute.where(schedule_level: @level).map { |ss| ss.substance }.uniq.sort { |a,b| a.to_s <=> b.to_s }
    @classifications = SubstanceClassification.where(schedule_level: @level).order(name: :asc)
  end

  def index
    @levels = RomanScheduleLevel::LEVELS
  end

  private

  def schedule_levels_params
    params.require(:id).permit(:schedule_level)
  end
end
