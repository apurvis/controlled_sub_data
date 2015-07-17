class StatuteAmendmentsController < StatutesController
  before_action :authenticate_user!

  def new
    if params['parent_id']
      @parent_statute = Statute.where(id: params['parent_id']).first
      @statute = StatuteAmendment.new(parent_id: @parent_statute.id, state: @parent_statute.state)
    else
      raise "NO parent id provided!"
    end
  end

  def create
#    puts "PARMS: #{params}"
#    puts "statute amend: #{statute_amendment_params}"
#    puts "statute: #{statute_params}"
#    puts "merge: #{statute_params.merge(statute_amendment_params)}"
    @parent_statute = Statute.where(id: statute_amendment_params['parent_id']).first
    @statute = StatuteAmendment.new(statute_params.merge(statute_amendment_params))
    @statute.state = @parent_statute.state # TODO: this shouldn't be necessary
    if @statute.save
      redirect_to @statute
    else
      render 'new'
    end
  end

  def update
    @statute = StatuteAmendment.where(id: params['id']).first

    if @statute.update(statute_params)
      redirect_to @statute
    else
      render 'edit'
    end
  end

  def index
    @statute_amendments = StatuteAmendment.all
  end

  def statute_amendment_params
    params.require(:statute_amendment).permit(:parent_id)
  end
end
