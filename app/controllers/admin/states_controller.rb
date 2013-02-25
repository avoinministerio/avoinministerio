class Admin::StatesController < Admin::AdminController
  respond_to :html

  def index
    respond_with @states = State.paginate(page: params[:page])
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
  
  private
  def resource
    @state ||= State.find(params[:id])
  end
end
