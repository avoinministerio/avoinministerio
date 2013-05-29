class LanguagesController < ApplicationController

  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to admin_languages_path }
      format.json { head :no_content }
    end
  end
  
  def selectlanguage
    finnish_speaking_countries=["finland", "estonia", "ingria", "karelia", "norway", "sweden"]
    if finnish_speaking_countries.include? request.location.country.downcase
      language="fi"
    else
      language="en"
    end
    render :json => {language: "#{language}"}
  end
  
end