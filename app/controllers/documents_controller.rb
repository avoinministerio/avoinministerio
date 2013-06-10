class DocumentsController < ApplicationController
  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to :back    
  end
end
