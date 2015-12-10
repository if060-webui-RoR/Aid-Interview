class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    if params[:waiting_approval]
      @users = User.waiting_approval
    else
      @users = User.all
    end
  end
  
  def approve
    User.find(params[:id]).update(approved: true)
    redirect_to admin_users_path, notice: 'User Approved'
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, notice: 'User not found'
  end

  private

    def check_admin
      return true if current_user.admin?
      redirect_to authenticated_root_path, notice: 'Access Denied'
    end

end