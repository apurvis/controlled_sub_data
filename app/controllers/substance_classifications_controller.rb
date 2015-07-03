class SubstanceClassificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @classifications = SubstanceClassification.all
    @unclassified_count = Substance.where(substance_classification_id: nil).size
  end

  def show
    @classification = SubstanceClassification.where(id: params['id']).first
  end

  def edit
    @classification = SubstanceClassification.where(id: params['id']).first
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

  def update
    @classification = SubstanceClassification.where(id: params['id']).first

    if @classification.update(substance_classification_params)
      redirect_to @classification
    else
      render 'edit'
    end
  end

  private

  def substance_classification_params
    params.require(:substance_classification).permit(:name)
  end
end
