class Admin::LanguagesController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html
  
  def index
    respond_with @languages = Language.order(:name).paginate(page: params[:page], per_page: 500)
  end

  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to admin_languages_path }
      format.json { head :no_content }
    end
  end
end