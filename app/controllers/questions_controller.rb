class QuestionsController < ActionController::Base
  def index
    @questions = Question.all
  end
end
