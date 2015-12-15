class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  helper_method :sort_column, :sort_direction

  def index
    @users = (params[:waiting_approval] ?
        User.waiting_approval : User).order("#{sort_column} #{sort_direction}")
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

  def column_names
    ["first_name", "last_name"]
  end

    def sort_column
      column_names.include?(params[:column]) ? params[:column] : "first_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

end