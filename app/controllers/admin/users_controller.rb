module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    add_breadcrumb "users", :admin_users_path

    def index
      @users = params[:waiting_approval] ? User.waiting_approval : User.all
      @search = @users.search(params[:q])
      @users = @search.result
    end

    def approve
      User.find(params[:id]).update(approved: true)
      redirect_to admin_users_path, notice: 'User Approved'
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, notice: 'User not found'
    end

    def destroy
      @user = User.find(params[:id]).destroy
      flash[:success] = 'User deleted'
      redirect_to admin_users_path
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, notice: 'User not found'
    end

    private

    def check_admin
      return true if current_user.admin?
      redirect_to authenticated_root_path, notice: 'Access Denied'
    end
  end
end
