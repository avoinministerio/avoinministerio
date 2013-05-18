class LanguagesController < ApplicationController

  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to admin_languages_path }
      format.json { head :no_content }
    end
  end
end
