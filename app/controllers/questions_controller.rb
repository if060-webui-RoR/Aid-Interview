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

end
