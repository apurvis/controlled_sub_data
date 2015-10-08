class SubstanceStatutesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def show
    @substance_statute = SubstanceStatute.with_deleted.where(id: params['id']).first
  end

  def edit
    @substance_statute = SubstanceStatute.where(id: params['id']).first
  end

  def index
    @substance_statutes = SubstanceStatute.all
  end

  def new
    @statute = Statute.where(id: params['statute_id'].to_i).first
    @substance_statute = SubstanceStatute.new(statute_id: @statute.id)
  end

  def create
    temp_params = params['substance_statute']
    if prior_regulation = SubstanceStatute.where(substance_id: temp_params['substance_id'], statute_id: temp_params['statute_id']).first
      flash.alert = 'This substance is already scheduled by this statute!'
      redirect_to Statute.where(id: temp_params['statute_id']).first
    else
      @substance_statute = SubstanceStatute.new(substance_statutes_params)

      if @substance_statute.save
        redirect_to @substance_statute.statute
      else
        render 'new'
      end
    end
  end

  def update
    @substance_statute = SubstanceStatute.where(id: params['id']).first

    if @substance_statute.update(substance_statutes_params)
      redirect_to @substance_statute
    else
      render 'edit'
    end
  end

  def destroy
    @substance_statute = SubstanceStatute.where(id: params['id']).first

    if @substance_statute.substance_alternate_names.size > 0
      flash.alert = "You cannot delete this substance statute link until you remove the #{@substance_statute.substance_alternate_names.size} associated alternate names"
    else
      notice = "Successfully Deleted link from #{@substance_statute.statute.formatted_name} to #{@substance_statute.substance.name}"
      @substance_statute.destroy
      flash.notice = notice
    end

    redirect_to @substance_statute.statute
  end

  private

  def substance_statutes_params
    params.require(:substance_statute).permit(
      :substance_id,
      :statute_id,
      :schedule_level,
      :is_expiration,
      :comment,
      :include_salts,
      :include_derivatives,
      :include_mixtures,
      :include_isomers,
      :include_optical_isomers,
      :include_geometric_isomers,
      :include_positional_isomers,
      :include_salts_of_isomers,
      :include_salts_of_optical_isomers,
      :include_esters,
      :include_ethers,
      :include_compounds,
      :include_materials,
      :include_preparations
    )
  end
end
