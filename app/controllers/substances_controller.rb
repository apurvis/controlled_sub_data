class SubstancesController < ApplicationController
  before_action :authenticate_user!

  def index
    @substances = Substance.all.order('name ASC')
  end

  def show
    @substance = Substance.where(id: params['id']).first
  end

  def edit
    @substance = Substance.where(id: params['id']).first
  end

  def new
    @substance = Substance.new
  end

  def create
    @substance = Substance.new(substance_params)

    if @substance.save
      redirect_to @substance
    else
      render 'new'
    end
  end

  def update
    @substance = Substance.where(id: params['id']).first

    if @substance.update(substance_params)
      redirect_to @substance
    else
      render 'edit'
    end
  end

  def destroy
    @substance = Substance.where(id: params['id']).first

    if @substance.substance_statutes.size > 0
      raise "You can't delete a substance that still has links to statutes!  This one still links to #{@substance.substance_statutes.size} statutes."
    else
      @substance.destroy
    end
    redirect_to substances_path
  end

  private

  def substance_params
    params.require(:substance).permit(:name, :dea_code, :substance_classification_id, :chemical_formula, :chemical_formula_smiles_format)
  end
end
