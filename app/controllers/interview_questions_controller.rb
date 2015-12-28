class InterviewQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_interviewer


  def edit_multiple
    @interview = Interview.last
    @interviewquestions = InterviewQuestion.where(interview_id: @interview.id)
    @questions = @interview.template.questions.paginate(page: params[:page], per_page: 1)
  end

  def update_multiple
    @interview = Interview.last
    @interviewquestions = InterviewQuestion.update(params[:interviewquestions].keys, params[:interviewquestions].values).reject { |p| p.errors.empty? }
    if @interviewquestions.empty?
      flash[:notice] = "Interviews updated"
      redirect_to interview_path(@interview)
    else
      render 'edit_multiple'
    end
  end
  
  private

  def interviewquestion_params
    params.require(:interview_question).permit(:interview_id, :question_id, :comment, :mark)
  end

  def check_interviewer
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

end
