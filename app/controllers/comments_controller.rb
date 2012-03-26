class CommentsController < ApplicationController
  respond_to :js
  
  before_filter :authenticate_citizen!
  before_filter :load_resource
  
  def create
    @comment = @idea.comments.build(params[:comment])
    @comment.author = current_citizen
    if @comment.save
      flash[:notice] = I18n.t("comments.create")
      KM.identify(current_citizen)
      KM.push("record", "comment created", idea_id: @idea.id)
    end
  end
  
  private
  
  def load_resource
    @idea = Idea.find(params[:idea_id])
    @idea ||= raise ActiveRecord::RecordNotFound
  end
end
