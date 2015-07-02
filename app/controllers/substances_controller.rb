class SubstancesController < ApplicationController
  before_action :authenticate_user!

  def show
    @substance = Substance.where(id: params["id"]).first
  end

  def index
    @substances = Substance.all
  end

  def new
      @substance = Substance.new
  end

  def create
    render plain: params[:substance].inspect
  end

  private
  def substance_params
    params.require(:substance).permit(:name, :classification, :chemical_formula, :chemical_formula_smiles_format)
  end
end
