class StatutesController < ApplicationController
  before_action :authenticate_user!

  def show
    @statute = Statute.where(id: params["id"]).first
  end

  def edit
    @statute = Statute.where(id: params["id"]).first
  end

  def index
    @statutes = Statute.all
  end

  def new
    @statute = Statute.new
  end

  def create
    @statute = Statute.new(statute_params)

    if @statute.save
      redirect_to @statute
    else
      render 'new'
    end
  end

  private

  def statute_params
    params.require(:statute).permit(:name, :state, :start_date, :blue_book_code, :expiration_date)
  end
end
