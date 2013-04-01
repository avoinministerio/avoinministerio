class Admin::LocationsController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html

  def index
    respond_with @locations = Location.order(:name).paginate(page: params[:page], per_page: 500)
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])

    begin
      flash[:notice] = "Location updated." if @location.update_attributes(params[:location])
      redirect_to admin_locations_path
    rescue
      redirect_to :back
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to admin_locations_path }
      format.json { head :no_content }
    end
  end
end
