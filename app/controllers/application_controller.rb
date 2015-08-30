class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def vip_only
    unless current_user.vip? || current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end
end
