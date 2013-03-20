class ForkedIdeasController < ApplicationController
  before_filter :authenticate_citizen!, :except => :show
  respond_to :html
  
  def index
    @forked_ideas = ForkedIdea.find_all_by_author_id_and_translated_idea_id(current_citizen.id, params[:translated_idea_id])
  end
  
  def show
    @forked_idea = ForkedIdea.find(params[:id])
    @idea = @forked_idea.translated_idea.idea
  end
  
  def edit
    @forked_idea = ForkedIdea.find(params[:id])
    @translated_idea = @forked_idea.translated_idea
    @language = Language.find_by_name(@translated_idea.language).full_name
  end
  
  def fork
    translated_idea = TranslatedIdea.find(params[:translated_idea_id])
    @forked_idea = current_citizen.forked_ideas.build(:translated_idea_id => translated_idea.id, :title => translated_idea.title,
                              :body => translated_idea.body, :summary => translated_idea.summary)
    
    if @forked_idea.save
      flash[:success] = 'Forked idea was successfully created.'
      redirect_to idea_translated_idea_forked_idea_path(params[:idea_id], translated_idea.id, @forked_idea)
    else
      flash[:error] = "Already forked or try again later."
      redirect_to request.path.sub("/#{translated_idea.id}/forked_ideas/fork", '')
    end
  end
  
  def update
    @forked_idea = ForkedIdea.find(params[:id])
    translated_idea = @forked_idea.translated_idea
    
    if @forked_idea.update_attributes(params[:forked_idea])
      flash[:success] = 'Forked idea was successfully updated.'
      redirect_to idea_translated_idea_forked_idea_path(params[:idea_id], translated_idea.id, @forked_idea)
    else
      flash[:error] = "Sorry! Please try later."
      redirect_to "#{request.path}/edit"
    end
  end
  
  def send_pull_request
    @forked_idea = ForkedIdea.find(params[:id])
    
    if @forked_idea.update_attributes(:pull_request_at => Time.now)
      flash[:success] = 'Pull request sent successfully'
      redirect_to pull_requests_idea_translated_idea_forked_ideas_path(params[:idea_id], params[:translated_idea_id])
    else
      flash[:error] = "Sorry! Please try later."
      redirect_to idea_translated_idea_forked_ideas_path(params[:idea_id], params[:translated_idea_id])
    end
  end
  
  def pull_requests
    need_closed = (params[:closed] ? true : false)
    translated_idea = TranslatedIdea.find(params[:translated_idea_id])

    @pull_requests = translated_idea.forked_ideas.find(:all, :conditions => ['pull_request_at IS NOT NULL AND is_closed = ?', need_closed], :order => 'updated_at DESC')
  end
  
  def merge
    @forked_idea = ForkedIdea.find(params[:id])
    @translated_idea = @forked_idea.translated_idea
  end
  
  def close_pr
    @forked_idea = ForkedIdea.find(params[:id])

    if @forked_idea.update_attributes(:is_closed => true)
      flash[:success] = 'Pull request sent successfully'
      redirect_to pull_requests_idea_translated_idea_forked_ideas_path(params[:idea_id], params[:translated_idea_id], :closed => true)
    else
      flash[:error] = "Sorry! Please try later."
      redirect_to idea_translated_idea_forked_ideas_path(params[:idea_id], params[:translated_idea_id])
    end
  end
end
