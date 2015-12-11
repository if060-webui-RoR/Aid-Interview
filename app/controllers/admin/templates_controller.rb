class Admin::TemplatesController < ApplicationController
 # before_action :authenticate_user!
 # before_action :check_admin

  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
    prepare_params_js
  end

  def show
    @template = Template.find(params[:id])
    @questions_array = @template.questions.any? ? @template.questions : Array.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save && store_questions
      redirect_to admin_template_path(@template)
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
    prepare_params_js
  end

  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(template_params) && store_questions
      flash[:success] = 'Template updated'
      redirect_to admin_template_path(@template)
    else
      flash[:danger] = "Template has #{pluralize(@template.errors.count, 'error')}"
      render 'edit'
    end
  end

  def destroy
    Template.find(params[:id]).destroy
    flash[:success] = 'Template deleted'
    redirect_to admin_templates_path
  end

  def question
    @template = (params[:template_id] && params[:template_id] != 0) ? Template.find(params[:template_id]) : Template.new
    @questions_array = @template.questions.any? ? @template.questions : Array.new
    if params[:operation] == 'add'
      @questions_array.push(params[:question_id])
    elsif params[:operation] == 'remove'
      @questions_array.pop(params[:question_id])
    end
    if @template
      redirect_to edit_admin_template_path(@template)
    else
      redirect_to new_admin_template_path
    end
  end

  private

  def template_params
    params.require(:template).permit(:name)
  end

  def check_admin
    return true if current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

  # prepare parameters for javascript methods
  def prepare_params_js
    gon.template_edit = @template
    gon.questions = @template.questions.as_json
    gon.questions_all = Question.all.as_json
  end

  # store questions to the given template
  def store_questions
    @template.questions.clear  # clear the questions
    #reconsider @questions_array: here it does not exist
    @questions_array.each do |q|
      @template.questions << q
    end
   end
end
