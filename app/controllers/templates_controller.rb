include ActionView::Helpers::TextHelper

class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_template, only: [:save_template]
  add_breadcrumb "templates", :templates_path

  def index
    @templates = Template.order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
  end

  def new
    @template = Template.new
    @template.id = 0
    add_breadcrumb 'new_template', new_template_path
  end

  def show
    @template = Template.find(params[:id])
    @questions_array = @template.questions.any? ? @template.questions : []
    add_breadcrumb @template.name, template_path(@template)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Template does not exist!'
    redirect_to templates_path
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      flash[:success] = 'Template was successfully created'
      redirect_to template_path(@template)
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, edit_template_path(@template)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Template does not exist!'
    redirect_to templates_path
  end

  def update
    redirect_to templates_path
  end

  def destroy
    Template.find(params[:id]).destroy
    flash[:success] = 'Template deleted'
    redirect_to templates_path
  end

  def save_template
    return unless @template
    @template.questions.clear
    return unless params[:questions]
    questions = params[:questions]
    questions.each do |_id, qst|
      qst = Question.where(:id => qst[:id])
      @template.questions << qst if qst
    end
    redirect_to template_path(@template)
  end

  def show_json
    if params[:id] == '0'
      render json: []
    else
      @questions = Template.find(params[:id]).questions
      questions = { json: @questions }
      render questions
    end
  end

  def show_json_topic
    @questions = Question.where(:topic_id => params[:id])
    questionstopic = { json: @questions }
    render questionstopic
  end

  def show_json_all_templates
    @templates = Template.all
    templates_all = { json: @templates }
    render templates_all
  end

  private

  def template_params
    params.require(:template).permit(:name)
  end

  def check_admin
    return true unless current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end

  def find_template
    if params[:id] == '0'
      @template = Template.create!(name: params[:name])
    else
      @template = Template.find(params[:id])
      @template.update_attributes(name: params[:name]) if @template
    end
  end
end
