class TopicsController < ApplicationController

  def index
    @topics = Topic.paginate(page: params[:page], per_page: 8)
  end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.find(params[:id])
    @questions = Question.where(topic_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = "Topic does not exist!"
      redirect_to topics_path
  end

  def create
    @topic = Topic.new(topic_params)
      respond_to do |format|
        if @topic.save
          format.html do
            redirect_to topics_path, notice: 'Topic was successfully    created'
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
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Topic does not exist!'
      redirect_to topics_path
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Topic updated'
      redirect_to topics_path
    else
      render 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @questions = Question.where(topic_id: params[:id])
      @questions.each do |q|
        q.update(topic_id: 1)
      end
    @topic.destroy
    flash[:success] = 'Topic deleted'
    redirect_to topics_path
  end
   
private

  def topic_params
    params.require(:topic).permit(:title)
  end
end
