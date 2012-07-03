class Admin::CitizensController < Admin::AdminController
  respond_to :html

  before_filter :build_resource, except: [ :index, :export ]

  def index
    respond_to do |wants|
      wants.html do
        @citizens = Citizen.paginate(page: params[:page])
      end
      wants.csv do
        today_date = Date.parse(params[:date] || "2012-01-01")
        csv_string = Citizen.to_csv(today_date, params[:page], 450)
        send_data(csv_string,
          type: 'text/csv; charset=UTF-8; header=present',
          disposition: "attachment; filename=#{Citizen.export_csv_file_name}")
      end
    end
  end

  def export
    Resque.enqueue(ExportCitizens)
    redirect_to :index
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