class Admin::IdeasController < Admin::AdminController
  include Admin::PublishingActions

  respond_to :html
  def index
    respond_with @ideas = Idea.paginate(page: params[:page])
  end

  def show
    respond_with resource
  end

  def edit
    @idea = Idea.find(params[:id])
    @city = City.find_by_name('Helsinki')
    @states = State.where(:city_id => @city.id).order(:rank)
    respond_with @idea
  end

  def update
    @idea = Idea.find(params[:id])
    if @idea.update_attributes(params[:idea])
      flash[:notice] = I18n.t("idea.updated")
      KM.identify(current_citizen)
      KM.push("record", "admin idea edited", idea_id: @idea.id,  idea_title: @idea.title)  # TODO use permalink title
    end
    respond_with @idea
  end

  def suggest_tags
    @idea = Tag.tags_suggestions(params)
    
    respond_to do |format|
      format.js   { render action: :citizen_voted, :locals => { :idea => @idea } }
    end
  end
  
  private
  def resource
    @idea ||= Idea.find(params[:id])
  end
end
