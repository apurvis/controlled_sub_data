class StatuteSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @states = Statute.pluck(:state).uniq
  end
end
