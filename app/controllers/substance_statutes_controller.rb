class SubstanceStatutesController < ApplicationController
  before_action :authenticate_user!

  def show
    @substance_statute = SubstanceStatute.where(id: params['id']).first
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
    @substance_statute = SubstanceStatute.new(substance_statutes_params)

    if @substance_statute.save
      redirect_to @substance_statute
    else
      render 'new'
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
  end

  private

  def substance_statutes_params
    params.require(:substance_statute).permit(
      :substance_id,
      :statute_id,
      :schedule_level,
      :is_expiration,
      :include_salts,
      :include_derivatives,
      :include_mixtures,
      :include_isomers,
      :include_optical_isomers,
      :include_geometric_isomers

      :include_positional_isomers,
      :include_salts_of_isomers,
      :include_salts_of_optical_isomers,
      :include_esters,
      :include_ethers,
      :include_compounds,
      :include_materials,
      :include_preparations.
    )
  end
end
