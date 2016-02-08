module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :load_users, only: [:index, :dashboard]

    def index
      @users = params[:waiting_approval] ? User.waiting_approval : User.all
      respond_to do |format|
        format.html
        format.json { render json: @users }
      end
      # @search = @users.search(params[:q] || {})
      # @users = @search.result.paginate(page: params[:page] || 1, per_page: 10).order(last_name: :asc)
      # add_breadcrumb "users", :admin_users_path
    end

    def dashboard
      @total_questions = Question.count
      @total_topics = Topic.count
    end

    def approve
      @user = User.find(params[:id]).update(approved: true)
      respond_to do |format|
        format.json { head :ok }
      end
    end

    def destroy
      @user = User.find(params[:id]).destroy
      respond_to do |format|
        format.json { head :ok }
      end
      # flash[:success] = 'User deleted'
      # redirect_to admin_users_path
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, notice: 'User not found'
    end

    private

    def check_admin
      return true if current_user.admin?
      redirect_to authenticated_root_path, notice: 'Access Denied'
    end

    def load_users
      @users = User.all
    end
  end
end
