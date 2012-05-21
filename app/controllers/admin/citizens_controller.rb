class Admin::CitizensController < Admin::AdminController
  respond_to :html
  
  before_filter :build_resource, except: [ :index ]
  
  def index
    respond_to do |wants|
        wants.html do
          @citizens = Citizen.paginate(page: params[:page])
        end
        wants.csv do
          send_data Citizen.export_all_citizens_to_csv(params[:page], params[:date]), 
            type: 'text/csv; charset=ISO-8859-1; header=present',
            disposition: "attachment; filename=citizens-#{Date.today.to_s}.csv"
        end
    end
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