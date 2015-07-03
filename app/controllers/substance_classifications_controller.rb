class SubstanceClassificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @classifications = SubstanceClassification.all
  end

  def show
    @classification = SubstanceClassification.where(id: params["id"]).first
  end

  def edit
    @classification = SubstanceClassification.where(id: params["id"]).first
  end

  def new
    @classification = SubstanceClassification.new
  end

  def create
    @classification = SubstanceClassification.new(substance_classification_params)

    if @classification.save
      redirect_to @classification
    else
      render 'new'
    end
  end

  private

  def substance_classification_params
    params.require(:substance_classification).permit(:name)
  end
end
