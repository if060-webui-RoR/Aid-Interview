class TemplatesController < ApplicationController

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to template_path(@template)
    else
      render 'new'
    end
  end

  private

  def template_params
    params.require(:template).permit(:name)
  end

end
