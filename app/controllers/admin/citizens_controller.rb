class Admin::CitizensController < Admin::AdminController
  respond_to :html
  
  def index
    respond_with @citizens = Citizen.all
  end
end