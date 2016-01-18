include ActionView::Helpers::TextHelper

class InterviewQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer
  before_action :update_interview_question, only: :update
  before_action :check_interview_question_mark, only: :update
  before_action :check_interview_end, only: :update
  add_breadcrumb "interview_questions", :interview_interview_questions_path

  def index
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_questions = @interview.interview_questions
    respond_to do |format|
      format.html
    end
  end

  def edit
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_question = @interview.interview_questions.find(params[:id])
    add_breadcrumb params[:id], edit_interview_interview_question_path(@interview, @interview_question)
  end

  def update
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_question = @interview.interview_questions.find(params[:id].to_i + 1)
    redirect_to edit_interview_interview_question_path(@interview, @interview_question)
  end

  private

  def interview_question_params
    params.require(:interview_question).permit(:interview_id, :question_id, :comment, :mark)
  end

  def check_interviewer
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

  def update_interview_question
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_question = @interview.interview_questions.find(params[:id])
    @interview_question.update(interview_question_params)
  end

  def check_interview_question_mark
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_question = @interview.interview_questions.find(params[:id])
    redirect_to edit_interview_interview_question_path(@interview, @interview_question) if (@interview_question.mark).nil?
  end

  def check_interview_end
    @interview = current_user.interviews.find(params[:interview_id])
    redirect_to interview_path(@interview) if @interview.interview_questions.last.id == params[:id].to_i
  end
end
