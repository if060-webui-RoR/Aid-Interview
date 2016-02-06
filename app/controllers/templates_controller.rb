include ActionView::Helpers::TextHelper

class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  respond_to :json, :html
  add_breadcrumb "templates", :templates_path

  def index
    respond_with current_user.templates.order(created_at: :desc)
  end

  def new
    add_breadcrumb 'new_template', new_template_path
    respond_with Template.new
  end

  def show
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, template_path(@template)
    template = @template.as_json
    template['question_ids'] = @template.question_ids.map(&:to_s)
    respond_with template
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Template does not exist!'
    redirect_to templates_path
  end

  def create
    @template = current_user.templates.create(template_params)
    @questions = Question.where(:id => params[:question_ids])
    if @template.save
      @template.questions = @questions
      flash[:success] = 'Template was successfully created'
      respond_with(@template)
    else
      flash[:danger] = 'Template does not exist!'
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, edit_template_path(@template)
    respond_with(@template)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Template does not exist!'
    redirect_to templates_path
  end

  def update
    @template = Template.find(params[:id])
    @questions = Question.where(:id => params[:question_ids])
    @template.questions = @questions
    if @template.update_attributes(name: template_params[:name])
      flash[:success] = 'Template updated'
      respond_with(@template)
    else
      render 'edit'
    end
  end

  def destroy
    respond_with Template.destroy params[:id]
  end

  private

  def template_params
    params.require(:template).permit(:name, :question_ids => [])
  end

  def check_admin
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end
end
