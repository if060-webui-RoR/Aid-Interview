class QuestionsController < ApplicationController
  def index
    @questions = Question.paginate(page: params[:page])
  end

  def show
    if current_user.admin?
      if params[:id].to_i > 0 && params[:id].to_i <= Question.all.count
        @question = Question.find(params[:id])
      else
        flash.now[:error] = "Question does not exist"
        render 'index' and return
      end
    else
      flash.now[:error] = "You are not admin"
      render 'devise/sessions/new'
    end
  end
  
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to question_path(@question)
    else
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
    params.require(:question).permit(:content, :answer)
  end
end
