class Admin::CommentsController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html
  
  def index
    @comments = resource_scope.paginate(page: params[:page])
  end
  
  def show
    respond_with resource
  end
    
  private
  
  def resource
    @comment ||= resource_scope.find(params[:id])
  end
  
  def resource_scope
    if params[:idea_id]
      Idea.find(params[:idea_id]).comments
    else
      Comment
    end
  end
end
