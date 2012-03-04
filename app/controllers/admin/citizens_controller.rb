class Admin::CitizensController < Admin::AdminController
  respond_to :html
  
  before_filter :build_resource, except: [ :index ]
  
  def index
    @citizens = Citizen.all
    respond_to do |wants|
        wants.html
        wants.csv do
          csv_string = CSV.generate do |csv|
            csv << ["email", "firstname", "lastname"]
            @citizens.each do |citizen|
              csv << [citizen.email, citizen.first_name, citizen.last_name]
            end
          end
          send_data csv_string, 
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