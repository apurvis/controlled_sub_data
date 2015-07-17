class StatutesController < ApplicationController
  before_action :authenticate_user!

  def index
    @statutes = Statute.where(type: nil).all
  end

  def show
    @statute = Statute.where(id: params['id']).first

    # First collect the original statute data
    @substance_statute_data = @statute.substance_statutes.map do |ss|
      {
        substance: ss.substance,
        start_date: @statute.start_date,
        added_by_amendment: nil,
        expired_by_amendment: ss.expiring_amendment
      }
    end

    # Then collect the amendment additions
    @statute.statute_amendments.each do |amendment|
      amendment.substance_statutes.each do |substance_change|
        @substance_statute_data << {
          substance: substance_change.substance,
          start_date: amendment.start_date,
          added_by_amendment: amendment,
          expired_by_amendment: 'broken_for_now'
        }
      end
    end
  end

  def edit
    @statute = Statute.where(id: params['id']).first
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

  def update
    @statute = Statute.where(id: params['id']).first

    if @statute.update(statute_params)
      redirect_to @statute
    else
      render 'edit'
    end
  end

  private

  def statute_params
    params.require(:statute).permit(:name, :state, :start_date, :blue_book_code, :expiration_date)
  end
end
