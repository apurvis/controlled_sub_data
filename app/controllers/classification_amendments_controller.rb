class ClassificationAmendmentsController < SubstanceClassificationsController
  def new
    if params[:parent_id]
      @parent = SubstanceClassification.where(id: params[:parent_id]).first
    end
    @classification_amendment = ClassificationAmendment.new(parent_id: params[:parent_id], statute_id: params[:statute_id])
  end

  def edit
    @classification_amendment = ClassificationAmendment.where(id: params[:id]).first
    @parent = @classification_amendment.substance_classification
  end

  def create
    if substance_classification_params[:parent_id].blank?
      flash.alert = 'No parent classification provided!'
      redirect_to substance_classifications_path
    else
      @classification_amendment = ClassificationAmendment.new(substance_classification_params)

      if @classification_amendment.save
        redirect_to @classification_amendment
      else
        render 'new'
      end
    end
  end

  def update
    @classification_amendment = ClassificationAmendment.where(id: params[:id]).first

    if @classification_amendment.update(substance_classification_params)
      redirect_to @classification_amendment
    else
      render 'edit'
    end
  end

  def substance_classification_params
    params.require(:classification_amendment).permit([:comment, :statute_id, :parent_id, :schedule_level, :name] + SubstanceClassification.available_flags)
  end
end
