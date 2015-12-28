class InterviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer
  add_breadcrumb "interviews", :interviews_path
  def index
    @interviews = Interview.paginate(page: params[:page], :per_page => 5)
  end
	
  def new
    @interview = Interview.new
    add_breadcrumb "new_interview", new_interview_path
  end

  def show
    @interview = Interview.find(params[:id])
    add_breadcrumb @interview.id, interview_path(@interview)
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Interview does not exist!'
      redirect_to interviews_path
  end

  def create
    @interview = Interview.new(interview_params)
    @interviewquestions = InterviewQuestion.where(interview_id: @interview.id)
    if @interview.save
      @questions = @interview.template.questions
      @questions.each do |q|
        InterviewQuestion.create(interview_id: @interview.id, question_id: q.id)
      end 
      redirect_to edit_multiple_interview_questions_path, notice: 'Interview was successfully created'
    else
      render 'new'
    end
  end

  def destroy
    Interview.find(params[:id]).destroy
    flash[:success] = 'Interview deleted'
    redirect_to interviews_path
  end

  def edit
    @interview = Interview.find(params[:id])
    @questions = @interview.template.questions
    add_breadcrumb @interview.id, edit_interview_path(@interview)
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Interview does not exist!'
      redirect_to interviews_path
  end

  def update
    @interview = Interview.find(params[:id])
    if @interview.update_attributes(interview_params)
      flash[:success] = 'Interview ended'
      redirect_to interview_path(@interview)
    else
      render 'edit'
    end
  end


  private

  def interview_params
    params.require(:interview).permit(:firstname, :lastname, :target_level, :template_id, :user_id)
  end

  def interviewquestion_params
    params.require(:interview_question).permit(:interview_id, :question_id, :comment, :mark)
  end

  def check_interviewer
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

end
