class AuditsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @audits = Audit.order('created_at DESC').paginate(page: params[:page])
  end
end
