class SubstancesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    if params[:search]
      substance_ids = Substance.select('substances.id')
                               .joins('LEFT JOIN substance_statutes ON substance_statutes.substance_id=substances.id')
                               .joins('LEFT JOIN substance_alternate_names ON substance_alternate_names.substance_statute_id=substance_statutes.id')
                               .where("LOWER(substances.name) LIKE '%#{params[:search][:substring].downcase}%'
                                    OR LOWER(substance_alternate_names.name) LIKE '%#{params[:search][:substring].downcase}%'
                                    OR LOWER(substances.chemical_formula) LIKE '%#{params[:search][:substring].downcase}%'
                                    OR chemical_formula_smiles_format LIKE '%#{params[:search][:substring].downcase}%'
                                    OR LOWER(substance_statutes.comment) LIKE '%#{params[:search][:substring].downcase}%'
                                    OR LOWER(substances.comment) LIKE '%#{params[:search][:substring].downcase}%'").to_a
      @substances = Substance.where(id: substance_ids)
    else
      @substances = Substance.includes(substance_statutes: [:substance_alternate_names, :statute, :substance_classification])
    end
    @substances = @substances.order('LOWER(substances.name) ASC').paginate(page: params[:page])
  end

  def show
    @substance = Substance.with_deleted.where(id: params['id']).first
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
    params.require(:substance).permit(:name, :dea_code, :chemical_formula, :chemical_formula_smiles_format, :comment)
  end
end
