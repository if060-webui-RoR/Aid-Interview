class TopicsController < ApplicationController

  def index
    @topics = Topic.paginate(page: params[:page])
  end


  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

      respond_to do |format|
        if @topic.save
          format.html do
            redirect_to topics_path, notice: 'Topic was successfully created.'
          end
          format.json { render :show, status: :created, location: @topic }
        else
          format.html { render :new }
          format.json do
            render json: @topic.errors, status: :unprocessable_entity
          end
        end
      end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Topic updated'
      redirect_to @topic
    else
      render 'edit'
    end
  end

private

  def topic_params
    params.require(:topic).permit(:title)
  end
end

