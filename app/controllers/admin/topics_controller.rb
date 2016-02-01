module Admin
  class TopicsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    respond_to :json, :html
    # skip_before_action :verify_authenticity_token
    def index
      @topics = Topic.all
      @topics.each do |t|
        t.image_file_name = t.image.url(:thumb)
      end
      respond_with @topics
    end

    def new
      respond_with Topic.new
    end

    def show
      @topic = Topic.find(params[:id])
      add_breadcrumb @topic.title, admin_topic_path(@topic)
      @questions = @topic.questions
      @data = { questions: @questions, topic: @topic }
      respond_with @data
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Topic doesn't exist!" }, status: 404
    end

    def create
      @topic = Topic.new(topic_params)
      @topic.image = decode_base64 if params[:image]
      if @topic.save
        render json: { response: "Topic was successfully created" }, status: 200
      else
        render json: { error: "Topic already exist!" }, status: 409
      end
    end

    def decode_base64
      decoded_data = Base64.decode64(params[:image][:base64])
      data = StringIO.new(decoded_data)
      data.class_eval do
        attr_accessor :content_type, :original_filename
      end
      data.content_type = params[:image][:filetype]
      data.original_filename = params[:image][:filename]
      data
    end

    def edit
      @topic = Topic.find(params[:id])
      respond_with :admin, @topic
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Topic doesn't exist!" }, status: 404
    end

    def update
      @topic = Topic.find(params[:id])
      @topic.update_attributes(image: decode_base64) if params[:image]
      if @topic.update_attributes(topic_params)
        render json: { response: "Topic was successfully updated" }, status: 200
      else
        render json: { error: "Topic already exist!" }, status: 409
      end
    end

    def destroy
      @topic = Topic.find(params[:id])
      if @topic.questions.empty?
        @topic.destroy
        render json: { response: "Topic was successfully deleted" }, status: 200
      else
        render json: { error: "You can not delete topic with questions" }, status: 409
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
