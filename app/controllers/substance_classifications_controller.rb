class SubstanceClassificationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @classification = SubstanceClassification.where(id: params["id"]).first
  end

  def index
    @classifications = SubstanceClassification.all
  end

  def new
    @classification = SubstanceClassification.new
  end

  def create
    render plain: params[:substance_classification].inspect
  end

  private

  def substance_classification_params
    params.require(:substance_classification).permit(:name)
  end
end
