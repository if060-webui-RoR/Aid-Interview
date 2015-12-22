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
      if @interview.save
        redirect_to interview_path(@interview), notice: 'Interview was successfully created'
      else
        render :new
      end
  end

  def destroy
    Interview.find(params[:id]).destroy
    flash[:success] = 'Interview deleted'
    redirect_to :back
  end


  private

  def interview_params
    params.require(:interview).permit(:firstname, :lastname, :target_level, :template_id, :user_id)
  end

  def check_interviewer
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

end
