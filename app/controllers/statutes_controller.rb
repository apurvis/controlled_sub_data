class StatutesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search]
      @substance = Substance.where(id: params[:search][:substance_id]).first
      @statutes = @substance.regulated_by_statutes
    else
      @statutes = Statute.where(type: nil).all
    end
  end

  def show
    @statute = Statute.where(id: params['id']).first

    # First collect the federal duplicates
    @statute.duplicated_federal_substance_statutes.each do |federal_dupe|
      substance_statute: federal_dupe,
      substance: federal_dupe.substance,
      start_date: @duplicate_federal_as_of_date,
      added_by_amendment: nil,
      is_expiration: false,
      expired_by_amendment: substance_change.expiring_amendment,
      schedule_level: federal_dupe.schedule_level
    end

    # First collect the original statute data
    @substance_statute_data = @statute.substance_statutes.map do |ss|
      {
        substance_statute: ss,
        substance: ss.substance,
        start_date: @statute.start_date,
        added_by_amendment: nil,
        is_expiration: ss.is_expiration,
        expired_by_amendment: ss.expiring_amendment,
        schedule_level: ss.schedule_level
      }
    end

    # Then collect the amendment additions
    @statute.statute_amendments.each do |amendment|
      amendment.substance_statutes.additions.each do |substance_change|
        @substance_statute_data << {
          substance_statute: substance_change,
          substance: substance_change.substance,
          start_date: amendment.start_date,
          added_by_amendment: amendment,
          is_expiration: substance_change.is_expiration?,
          expired_by_amendment: substance_change.expiring_amendment,
          schedule_level: substance_change.schedule_level
        }
      end
    end

    puts "---"
    puts @substance_statute_data
    puts "---"
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
    params.require(:statute).permit(
      :name,
      :state,
      :parent_id,
      :start_date,
      :blue_book_code,
      :expiration_date,
      :duplicate_federal_as_of_date
    )
  end
end
