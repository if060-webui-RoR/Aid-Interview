module Admin
  class TopicsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    respond_to :json, :html
    # skip_before_action :verify_authenticity_token
    add_breadcrumb "topics", :admin_topics_path
    def index
      respond_with Topic.all
    end

    def new
      respond_with Topic.new
      add_breadcrumb "new topic", new_admin_topic_path
    end

    def show
      @topic = Topic.find(params[:id])
      add_breadcrumb @topic.title, admin_topic_path(@topic)
      @questions = @topic.questions.paginate(page: params[:page], :per_page => 10)
      respond_with :admin, @topic
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Topic does not exist!'
      redirect_to admin_topics_path
    end

    def create
      @topic = Topic.new(topic_params)
      if @topic.save
        flash[:success] = 'Topic was successfully created'
        respond_with :admin, @topic, location: -> { admin_topics_path }
      else
        flash[:danger] = 'Topic already not exist!'
        render 'new'
      end
    end

    def edit
      @topic = Topic.find(params[:id])
      respond_with :admin, @topic
      add_breadcrumb @topic.title, edit_admin_topic_path(@topic)
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Topic does not exist!'
      redirect_to admin_topics_path
    end

    def update
      @topic = Topic.find(params[:id])
      if @topic.update_attributes(topic_params)
        flash[:success] = 'Topic updated'
        respond_with :admin, @topic
      else
        render 'edit'
      end
    end

    def destroy
      @topic = Topic.find(params[:id])
      if @topic.questions.empty?
        @topic.destroy
        flash[:success] = 'Topic deleted'
        respond_with :admin, @topic
      else
        flash[:danger] = 'You can not delete topic with questions!'
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :image)
    end

    def check_admin
      return true if current_user.admin?
      redirect_to authenticated_root_path, notice: 'Access Denied'
    end
  end
end
