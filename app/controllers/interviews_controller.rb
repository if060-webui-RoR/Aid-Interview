include ActionView::Helpers::TextHelper

class InterviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer
  add_breadcrumb "interviews", :interviews_path
  def index
    @interviews = current_user.interviews
    @search = @interviews.search(params[:q] || {})
    @interviews = @search.result.paginate(page: params[:page] || 1, per_page: 6).order(created_at: :desc)
  end

  def new
    @interview = current_user.interviews.new
    add_breadcrumb "new_interview", new_interview_path
  end

  def show
    @interview = current_user.interviews.find(params[:id])
    add_breadcrumb @interview.id, interview_path(@interview)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Interview does not exist!'
    redirect_to interviews_path
  end

  def create
    @interview = current_user.interviews.create(interview_params)
    @interview.questions.each do |q|
      @interview.interview_questions.create(question_id: q.id)
    end
    @interview_question = @interview.interview_questions.first
    redirect_to edit_interview_interview_question_path(@interview, @interview_question)
  end

  def destroy
    current_user.interviews.find(params[:id]).destroy
    flash[:success] = 'Interview deleted'
    redirect_to interviews_path
  end

  private

  def interview_params
    params.require(:interview).permit(:firstname, :lastname, :target_level, :template_id, :user_id)
  end

  def check_interviewer
    redirect_to authenticated_root_path, notice: 'Access Denied' if current_user.admin?
  end
end
