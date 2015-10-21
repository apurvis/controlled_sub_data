class AuditsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @audits = Audited::Adapters::ActiveRecord::Audit.where('user_id <> 8').reorder('created_at DESC').paginate(page: params[:page])
  end
end
