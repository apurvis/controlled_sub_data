class StatutesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    if params[:search]
      @as_of_date = params[:search][:as_of_date].try(:to_date)

      if params[:search][:substance_id].blank? && params[:search][:state].blank?
        flash.alert = 'Must specify either a substance or a state to search'
        redirect_to statute_searches_path
      elsif !params[:search][:substance_id].blank? && !params[:search][:state].blank?
        flash.alert = 'Can only search by substance or by state, not both.'
        redirect_to statute_searches_path
      elsif !params[:search][:substance_id].blank?
        @substance = Substance.where(id: params[:search][:substance_id]).first
        @statutes = @substance.regulated_by_statutes(@as_of_date)
      else
        @statutes = Statute.where(state: params[:search][:state], type: nil).all
        if @statutes.empty?
          flash.alert = "No statute data yet for #{params[:search][:state]}!"
          redirect_to statute_searches_path
        elsif @statutes.size > 1
          flash.alert = "More than 1 statute found for #{params[:search][:state]}; this is not well supported yet."
          redirect_to statute_searches_path
        else
          redirect_to statute_path(@statutes.first, as_of_date: @as_of_date)
        end
      end
    else
      @statutes = Statute.where(type: nil).all
    end
  end

  def show
    @statute = Statute.where(id: params['id']).first
    @as_of_date = params[:as_of_date].try(:to_date)

    if @statute.is_a?(StatuteAmendment)
      @scheduled_substance_message = 'Add a substance to/Expire a substance from this statute'
    else
      @scheduled_substance_message = 'Add a substance to this statute'
    end

    # First collect the federal duplicates
    @substance_statute_data = @statute.duplicated_federal_substance_statutes.map do |federal_dupe|
      {
        substance_statute: federal_dupe,
        substance: federal_dupe.substance,
        start_date: @statute.duplicate_federal_as_of_date,
        added_by_amendment: '',
        is_expiration: false,
        expired_by_amendment: federal_dupe.expiring_amendment(@as_of_date),
        schedule_level: federal_dupe.schedule_level
      }
    end

    # Next collect any actual statute data
    @statute.substance_statutes.each do |ss|
      @substance_statute_data << {
        substance_statute: ss,
        substance: ss.substance,
        start_date: @statute.start_date,
        added_by_amendment: nil,
        is_expiration: ss.is_expiration,
        expired_by_amendment: ss.expiring_amendment(@as_of_date),
        schedule_level: ss.schedule_level
      }
    end

    # Then collect the amendment additions
    @statute.statute_amendments.each do |amendment|
      amendment.substance_statutes.additions.each do |ss|
        @substance_statute_data << {
          substance_statute: ss,
          substance: ss.substance,
          start_date: amendment.start_date,
          added_by_amendment: amendment,
          is_expiration: ss.is_expiration?,
          expired_by_amendment: ss.expiring_amendment(@as_of_date),
          schedule_level: ss.schedule_level
        }
      end
    end

    @substance_statute_data.select! { |s| s[:start_date] <= @as_of_date } if @as_of_date
    @substance_statute_data.sort! do |a,b|
      if a[:start_date] < b[:start_date]
        -1
      elsif a[:start_date] > b[:start_date]
        1
      else
        a[:substance].name <=> b[:substance].name
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

  def destroy
    @statute = Statute.where(id: params['id']).first

    if @statute.statute_amendments.size > 0
      flash.alert = "You can't delete a statute that still has amendments!  This has #{@statute.statute_amendments.size} amendments; please remove them first and try again."
    elsif @statute.substance_statutes.size > 0
      flash.alert = "You can't delete a statute that still has links to substances!  This one still links to #{@statute.substance_statutes.size} substances.  Please delete the links between this substance and its statutes through the statutes page and then try again."
    else
      notice = "Successfully deleted statute #{@statute.formatted_name}"
      @statute.destroy
      flash.notice = notice
    end

    if @statute && @statute.is_a?(StatuteAmendment)
      redirect_to @statute.statute
    else
      redirect_to statutes_path
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
      :duplicate_federal_as_of_date,
      :comment
    )
  end
end
