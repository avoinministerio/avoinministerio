class Admin::StatesController < Admin::AdminController
  skip_before_filter :current_location, :only => [:select_location, :set_your_location, :fetch_dependents]
  
  respond_to :html
  
  def index
    respond_with @states = @current_location.states.order(:rank).paginate(page: params[:page])
  end
  
  def show
    respond_with resource
  end
  
  def new
    @state = State.new
    respond_with @state
  end
  
  def create
    @state = State.new(params[:state])
    if @state.save
      flash[:notice] = I18n.t("state.created") 
      KM.identify(current_citizen)
      KM.push("record", "admin state created", state_id: @state.id,  state_name: @state.name)
    end
    respond_with :admin, @state
  end
  
  def edit
    @state = State.find(params[:id])
    respond_with @state
  end
  
  def update
    @state = State.find(params[:id])
    if @state.update_attributes(params[:state])
      flash[:notice] = I18n.t("state.updated") 
      KM.identify(current_citizen)
      KM.push("record", "admin state edited", state_id: @state.id,  state_name: @state.name)
    end
    respond_with :admin, @state
  end
  
  def destroy
    @state = State.find(params[:id])
    @state.destroy
    
    redirect_to admin_states_path
  end
  
  def set_your_location
    begin
      session[:current_city] = City.find(params[:city_id])
      
      redirect_to '/admin'
    rescue
      flash[:error] = 'Please select state/city'
      redirect_to select_location_admin_states_path
    end
  end
  
  def fetch_dependents
    options = eval("#{params[:dep_type].classify}.find_all_by_#{params[:res_type]}_id(#{params[:res_id]})")
    
    render :json => { :options => options }
  end
  
  private
  def resource
    @state ||= State.find(params[:id])
  end
end
