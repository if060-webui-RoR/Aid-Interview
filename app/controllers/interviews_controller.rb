include ActionView::Helpers::TextHelper

class InterviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer
  before_action :check_interview, only: [:create]
  add_breadcrumb "interviews", :interviews_path
  def index
    @interviews = Interview.order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
  end

  def new
    @interview = Interview.new
    add_breadcrumb "new_interview", new_interview_path
  end

  def show
    @interview = Interview.find(params[:id])
    @questions = @interview.questions
    add_breadcrumb @interview.id, interview_path(@interview)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Interview does not exist!'
    redirect_to interviews_path
  end

  def create
    @interview = Interview.new(interview_params)
    if @interview.save
      @interview.questions.each do |q|
        @interview.interview_questions.create(interview_id: @interview.id, question_id: q.id)
        @interview_question = @interview.interview_questions.first
      end
      redirect_to edit_interview_interview_question_path(@interview, @interview_question)
    else
      render 'new'
    end
  end

  def destroy
    @interview = Interview.find(params[:id])
    if @interview.user_id == current_user.id
      @interview.destroy
      flash[:success] = 'Interview deleted'
    else
      flash[:danger] = "You don't have permission to delete"
    end
    redirect_to interviews_path
  end

  private

  def interview_params
    params.require(:interview).permit(:firstname, :lastname, :target_level, :template_id, :user_id)
  end

  def check_interviewer
    redirect_to authenticated_root_path, notice: 'Access Denied' if current_user.admin?
  end

  def check_interview
    @interview = Interview.new(interview_params)
    redirect_to template_path(@interview.template), notice: 'Template is empty' if @interview.questions.empty?
  end
end
