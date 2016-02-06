class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    redirect_to dashboard_admin_users_path if current_user.admin?
    @total_templates = current_user.templates.count
    @total_interviews = current_user.interviews.count
  end
end
