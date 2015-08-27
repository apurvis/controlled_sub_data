class SubstanceAlternateNamesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    @substance_alternate_names = SubstanceAlternateName.all.sort { |a,b| a.name <=> b.name }
  end

  def show
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first
    @substance = @substance_alternate_name.substance || @substance_alternate_name.substance_statute.substance
    @statute = @substance_alternate_name.substance_statute.try(:statute)
  end

  def edit
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first
  end

  def new
    fail "No substance statute id supplied" unless params.has_key?(:substance_statute_id)

    @substance_alternate_name = SubstanceAlternateName.new
    @substance_alternate_name.substance_statute_id = params[:substance_statute_id]
    @substance_statute = SubstanceStatute.find_by_id(params[:substance_statute_id])
    @statute = @substance_statute.statute
    @substance = @substance_statute.substance
  end

  def create
    @substance_alternate_name = SubstanceAlternateName.new(substance_alternate_name_params)

    if @substance_alternate_name.save
      redirect_to @substance_alternate_name
    else
      render 'new'
    end
  end

  def update
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first

    if @substance_alternate_name.update(substance_alternate_name_params)
      redirect_to @substance_alternate_name
    else
      render 'edit'
    end
  end

  def destroy
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first
    @substance_statute = @substance_alternate_name.substance_statute
    notice = "Successfully deleted alternate name of #{@substance_alternate_name.name}"
    @substance_alternate_name.destroy
    flash.notice = notice

    if @substance_statute
      redirect_to substance_statute_path(@substance_statute)
    else
      redirect_to substance_alternate_names_path
    end
  end

  private

  def substance_alternate_name_params
    params.require(:substance_alternate_name).permit(:name, :substance_statute_id)
  end
end
