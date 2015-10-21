class SubstanceClassificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    @classifications = SubstanceClassification.all
    @unclassified_count = SubstanceStatute.where(substance_classification_id: nil).size
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

  def destroy
    @classification = SubstanceClassification.where(id: params['id']).first

    if @classification.substances.size > 0
      flash.alert = "You can't delete a classification that still has #{@classification.substances.size} substances attached!"
    else
      notice = "Successfully deleted #{@classification.name}"
      @classification.destroy
      flash.notice = notice
    end

    redirect_to substance_classifications_path
  end

  private

  def substance_classification_params
    params.require(:substance_classification).permit(:name)
  end
end
