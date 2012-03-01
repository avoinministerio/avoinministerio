class Admin::CitizensController < Admin::AdminController
  respond_to :html
  
  before_filter :build_resource, except: [ :index ]
  
  def index
    respond_with @citizens = Citizen.all
  end
  
  def show
    respond_with @citizen
  end
  
  def lock
    @citizen.lock!
    redirect_to :back
  end
  
  def unlock
    @citizen.unlock!
    redirect_to :back
  end
  
  private
  
  def build_resource
    @citizen = Citizen.find(params[:id])
  end
end