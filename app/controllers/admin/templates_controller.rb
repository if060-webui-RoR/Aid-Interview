class Admin::TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
  end

  def show
    @template = Template.find(params[:id])
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to template_path(@template)
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
  end


  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(template_params)
      flash[:success] = 'Template updated'
      redirect_to @template
    else
      flash[:danger] = "Template has #{pluralize(@template.errors.count, 'error')}"
      render 'edit'
    end
  end

  def destroy
    Template.find(params[:id]).destroy
    flash[:success] = 'Template deleted'
    redirect_to templates_path
  end

  private

  def template_params
    params.require(:template).permit(:name)
  end

  def check_admin
    return true if current_user.admin?
    redirect_to authenticated_root_path, notice: 'Access Denied'
  end
end
