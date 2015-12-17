include ActionView::Helpers::TextHelper

class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  add_breadcrumb "templates", :admin_templates_path
  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
    add_breadcrumb "new_template", new_admin_template_path
  end

  def show
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, admin_template_path(@template)
  end

  def create
    @template = Template.new(template_params)
    @questions = Question.where(:id => params[:template][:question_ids])
    @template.questions = @questions
    if @template.save
      redirect_to admin_template_path(@template)
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, edit_admin_template_path(@template)
  end


  def update
    @template = Template.find(params[:id])
    @questions = Question.where(:id => params[:template][:question_ids])
    @template.questions = @questions
    if @template.update_attributes(name: template_params[:name])
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

  private

  def template_params
    params.require(:template).permit(:name, :question_ids => [])
  end

  def check_admin
    return true if current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end
end
