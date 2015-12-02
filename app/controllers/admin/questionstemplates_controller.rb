class Admin::QuestionstemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  def create
    template = Template.find(params[:template_id])
    template.questionstemplates.create!(questionstemplate_params)
    redirect_to admin_template_path(template)
  end

  def destroy
    questionstemplate = Questionstemplate.find(params[:id])
    template = questionstemplate.template
    questionstemplate.destroy
    redirect_to admin_template_path(template)
  end


  private

  def questionstemplate_params
    params.require(:questionstemplate).permit(:question_id)
  end

  def check_admin
    return true if current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end
end