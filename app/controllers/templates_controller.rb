include ActionView::Helpers::TextHelper

class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  skip_before_action :verify_authenticity_token
  add_breadcrumb "templates", :templates_path

  def index
    @templates = Template.paginate(page: params[:page], per_page: 8)
    respond_to do |format|
      format.json { render json: Template.all }
      format.html
    end
  end

  def new
    add_breadcrumb 'new_template', new_template_path
    @template = Template.new
  end

  def show
    @template = Template.find(params[:id])
    add_breadcrumb @template.name, template_path(@template)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Template does not exist!'
    redirect_to templates_path
  end

  def create
    @template = Template.new(template_params)
    @questions = Question.where(:id => params[:question_ids])
    respond_to do |format|
      if @template.save
        @template.questions = @questions
        format.html { redirect_to templates_path, notice: 'Template was successfully created' }
        format.json { render :show, status: :created, location: @template }
      else
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @template = Template.find(params[:id])
    respond_with(@template)
    add_breadcrumb @template.name, edit_template_path(@template)
  end

  def update
    @template = Template.find(params[:id])
    @questions = Question.where(:id => params[:template][:question_ids])
    @template.questions = @questions
    if @template.update_attributes(name: template_params[:name])
      flash[:success] = 'Template updated'
      redirect_to template_path(@template)
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
