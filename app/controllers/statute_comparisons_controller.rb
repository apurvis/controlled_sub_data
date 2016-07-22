class StatuteComparisonsController < ApplicationController
  def index
    @states = Statute.pluck(:state).uniq
  end

  def new
    @state_one = params[:compare][:state_one]
    @state_two = params[:compare][:state_two]
    @as_of_date = params[:compare][:as_of_date].try(:to_date)

    if @state_one == @state_two
      flash.alert = 'Please choose different states to compare.'
      redirect_to statute_comparisons_path
    end

    # Avoid the amendments because their regulations are found in the effective_substance_statutes method
    @state_one_statutes = Statute.where(state: @state_one).where(type: nil)
    @state_two_statutes = Statute.where(state: @state_two).where(type: nil)

    if @as_of_date
      @state_one_statutes = @state_one_statutes.where(['start_date <= ?', @as_of_date])
      @state_two_statutes = @state_two_statutes.where(['start_date <= ?', @as_of_date])
    end

    @state_one_substance_statutes = @state_one_statutes.map { |s| s.effective_substance_statutes(as_of: @as_of_date) }.flatten.uniq
    @state_two_substance_statutes = @state_two_statutes.map { |s| s.effective_substance_statutes(as_of: @as_of_date) }.flatten.uniq

    @state_one_only = find_differences(@state_one_substance_statutes, @state_two_substance_statutes)
    @state_two_only = find_differences(@state_two_substance_statutes, @state_one_substance_statutes)
  end

  private

  def find_differences(statutes_1, statutes_2)
    statutes_1.map do |ss|
      next nil if statutes_2.any? { |ss2| ss.regulates_same_substance_flags?(ss2) }

      if (same_substance = statutes_2.select { |ss2| ss.substance_id == ss2.substance_id }.first)
        { difference: ss.regulation_differences(same_substance, as_of: @as_of_date).join(', '), substance_statute: ss }
      else
        { difference: 'Only Regulated Here', substance_statute:  ss }
      end
    end.compact.sort do |a, b|
      if a[:difference] < b[:difference]
        -1
      elsif a[:difference] > b[:difference]
        1
      else
        a[:substance_statute].substance.name <=> b[:substance_statute].substance.name
      end
    end
  end
end
