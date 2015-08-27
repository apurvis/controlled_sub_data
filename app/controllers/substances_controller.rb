class SubstancesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    @substances = Substance.order('name ASC').paginate(page: params[:page])
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
      flash.alert = "You can't delete a substance that still has links to statutes!.  This one still links to #{@substance.substance_statutes.size} statutes.  Please delete the links between this substance and its statutes through the statutes page and then try again."
    else
      notice = "Successfully deleted substance #{@substance.name}"
      @substance.destroy
      flash.notice = notice
    end
    redirect_to substances_path
  end

  private

  def substance_params
    params.require(:substance).permit(:name, :dea_code, :substance_classification_id, :chemical_formula, :chemical_formula_smiles_format)
  end
end
