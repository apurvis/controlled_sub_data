class StatuteAmendmentsController < StatutesController
  before_action :authenticate_user!

  def new
    if params['parent_id']
      @parent_statute = Statute.where(id: params['parent_id']).first
      @statute = StatuteAmendment.new(parent_id: @parent_statute.id, state: @parent_statute.state)
    else
      raise "No parent statute id provided!"
    end
  end

  def create
    # TODO: there is confusion about how the parent_id is being passed in the STI setting.
    # this works for now but is not ideal.
    @parent_statute = Statute.where(id: statute_amendment_params['parent_id']).first
    @statute = StatuteAmendment.new(statute_params.merge(statute_amendment_params))
    @statute.state = @parent_statute.state # TODO: this shouldn't be necessary but there is validates_presence_of :state

    if @statute.save
      redirect_to @statute
    else
      render 'new'
    end
  end

  def update
    @statute = StatuteAmendment.where(id: params['id']).first

    if @statute.update(statute_params.merge(statute_amendment_params))
      redirect_to @statute
    else
      render 'edit'
    end
  end

  def index
    @statute_amendments = StatuteAmendment.all
  end

  def statute_amendment_params
    params.require(:statute_amendment).permit(:parent_id, :blue_book_code, :comment)
  end
end
