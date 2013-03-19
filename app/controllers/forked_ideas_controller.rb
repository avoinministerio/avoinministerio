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
      begin
        redirect_to idea_translated_idea_forked_idea_path(params[:idea_id], translated_idea.id, @forked_idea)
      rescue Exception => e
        raise e 
      end
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
  
  # DELETE /forked_ideas/1
  # DELETE /forked_ideas/1.json
  def destroy
    @forked_idea = ForkedIdea.find(params[:id])
    @forked_idea.destroy
    
    respond_to do |format|
      format.html { redirect_to forked_ideas_url }
      format.json { head :no_content }
    end
  end
end
