class QuestionsController < ApplicationController
  def index
    @questions = Question.paginate(page: params[:page])
  end

  def show
    @questions = Question.all
    if params[:id].to_i <= @questions.count && params[:id].to_i > 0 
      if current_user.admin?
        @question = Question.find(params[:id])
      else
        render text: 'You are not admin' and return
      end
    else
      render text: 'Question does not exist'
    end   
  end

end
