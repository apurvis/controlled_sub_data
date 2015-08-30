class StatuteComparisonsController < ApplicationController
  def index
    @states = Statute.pluck(:state).uniq
  end

  def new
    @state_one = params[:compare][:state_one]
    @state_two = params[:compare][:state_two]
    @as_of_date = params[:compare][:as_of_date].try(:to_date)

    @state_one_statutes = Statute.where(state: @state_one)
    @state_two_statutes = Statute.where(state: @state_two)

    if @as_of_date
      @state_one_statutes = @state_one_statutes.where(['start_date <= ?', @as_of_date])
      @state_two_statutes = @state_two_statutes.where(['start_date <= ?', @as_of_date])
    end

    @state_one_substance_statutes = @state_one_statutes.map { |s| s.substance_statutes }.flatten
    @state_one_substance_statutes += @state_one_statutes.map { |s| s.duplicated_federal_substance_statutes }.flatten

    @state_two_substance_statutes = @state_two_statutes.map { |s| s.substance_statutes }.flatten
    @state_two_substance_statutes += @state_two_statutes.map { |s| s.duplicated_federal_substance_statutes }.flatten

    @state_one_only = []
    @state_two_only = []

    @state_one_substance_statutes.each do |ss|
      unless @state_two_substance_statutes.any? { |ss2| ss2.substance == ss.substance }
        @state_one_only << ss.substance
      end
    end

    @state_two_substance_statutes.each do |ss|
      unless @state_one_substance_statutes.any? { |ss2| ss2.substance == ss.substance }
        @state_two_only << ss.substance
      end
    end

    puts "state one only\n----"
    puts @state_one_only.map {|s| s.name}.join(",")
    puts "state two only\n----"
    puts @state_two_only.map {|s| s.name}.join(",")
  end
end
