include ActionView::Helpers::TextHelper

module Admin
  class QuestionsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    respond_to :json, :html
    def index
      respond_to do |format|
        format.json do
          page = params[:page].present? ? params[:page] : 1
          @questions = Question.all.paginate(:page => page, :per_page => 10)
          render :json => Paginator.pagination_attributes(@questions).merge!(:questions => @questions)
        end
        format.html
      end
    end

    def show
      @question = Question.find(params[:id])
      @topic = @question.topic
      respond_with :admin, @question
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Question does not exist!'
    end

    def new
      @question = Question.new
      respond_with @question
    end

    def create
      @question = Question.new(question_params)
      if @question.save
        flash[:success] = 'Question was successfully created'
        respond_with :admin, @question, location: -> { admin_questions_path }
      end
    end

    def edit
      @question = Question.find(params[:id])
      respond_with :admin, @question
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Question does not exist!'
    end

    def update
      @question = Question.find(params[:id])
      if @question.update_attributes(question_params)
        flash[:success] = 'Question updated'
      end
    end

    def destroy
      if Question.find(params[:id]).destroy
        render json: { response: "Question was successfully deleted" }, status: 200
      else
        render json: { error: "Something gone wrong!" }, status: 409
      end
    end

    private

    def question_params
      params.require(:question).permit(:topic_id, :content, :answer, :level)
    end

    def check_admin
      return true if current_user.admin?
      redirect_to authenticated_root_path, notice: 'Access Denied'
    end
  end
end
