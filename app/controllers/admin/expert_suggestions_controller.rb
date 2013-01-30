class Admin::ExpertSuggestionsController < Admin::AdminController
  respond_to :html

  def index
    respond_with @expert_suggestions = ExpertSuggestion.paginate(page: params[:page])
  end
  
  def show
    respond_with resource
  end
  
  private

  def resource
    @expert_suggestion ||= ExpertSuggestion.find(params[:id])
  end
end
