include ActionView::Helpers::TextHelper
class QuestionsController < ApplicationController
  def index
    @questions = Question.paginate(page: params[:page])
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = 'Question created'
      redirect_to question_path(@question)
    else
      flash[:danger] = "Question has #{pluralize(@question.errors.count, 'error')}"
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      flash[:success] = 'Question updated'
      redirect_to @question
    else
      flash[:danger] = "Question has #{pluralize(@question.errors.count, 'error')}"
      render 'edit'
    end
  end

  def destroy
    Question.find(params[:id]).destroy
    flash[:success] = 'Question deleted'
    redirect_to questions_url
  end

  private

  def question_params
    params.require(:question).permit(:topic_id, :content, :answer)
  end


end
