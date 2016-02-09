include ActionView::Helpers::TextHelper

class InterviewQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer
  add_breadcrumb "interview_questions", :interview_interview_questions_path

  def index
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_questions = @interview.interview_questions
  end

  def edit
    initialize_interview_question
    add_breadcrumb params[:id], edit_interview_interview_question_path(@interview, @interview_question)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Interview question does not exist!'
    redirect_to interviews_path
  end

  def update
    initialize_interview_question
    if @interview_question.update(interview_question_params)
      if @interview.interview_questions.last.id == params[:id].to_i
        redirect_to interview_path(@interview)
      else
        next_question
      end
    else
      render 'edit'
    end
  end

  private

  def interview_question_params
    params.require(:interview_question).permit(:interview_id, :question_id, :comment, :mark)
  end

  def check_interviewer
    redirect_to authenticated_root_path, notice: 'Access Denied' if current_user.admin?
  end

  def initialize_interview_question
    @interview = current_user.interviews.find(params[:interview_id])
    @interview_question = @interview.interview_questions.find(params[:id])
  end

  def next_question
    redirect_to edit_interview_interview_question_path(@interview, @interview.not_answered_first_question)
  end
end
