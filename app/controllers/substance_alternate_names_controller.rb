class SubstanceAlternateNamesController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    @substance_alternate_names = SubstanceAlternateName.all.sort { |a,b| a.name <=> b.name }
  end

  def show
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first
  end

  def edit
    @substance_alternate_name = SubstanceAlternateName.where(id: params['id']).first
  end

  def new
    @substance_alternate_name = SubstanceAlternateName.new
    @substance_alternate_name.substance_id = params[:substance_id] if params.has_key?(:substance_id)
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

  private

  def substance_alternate_name_params
    params.require(:substance_alternate_name).permit(:name, :substance_id)
  end
end
