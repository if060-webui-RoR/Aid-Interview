class TopicsController < ApplicationController
  def index
  	@topics = Topic.paginate(page: params[:page])
  end

  
  private
  def topic_params
    params.require(:topic).permit(:title)
  end
end
