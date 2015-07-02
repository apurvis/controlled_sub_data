class StatutesController < ApplicationController
  before_action :authenticate_user!

  def show
    @statute = Statute.where(id: params["id"]).first
  end

  def index
    @statutes = Statute.all
  end

  def new
    @statute = Statute.new
  end

  def create
    render plain: params[:statute].inspect
  end

  private

  def statute_params
    params.require(:statute).permit(:name, :state, :start_date, :blue_book_code, :expiration_date)
  end
end
