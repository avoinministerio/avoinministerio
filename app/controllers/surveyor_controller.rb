# encoding: UTF-8
module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    base.send :layout, 'application'
  end

  # Actions
  def new
    super
    # @title = "You can take these surveys"
  end
  def create
    surveys = Survey.where(:access_code => params[:survey_code]).order("survey_version DESC")
    if params[:survey_version].blank?
      @survey = surveys.first
    else
      @survey = surveys.where(:survey_version => params[:survey_version]).first
    end
    @response_set = ResponseSet.
      create(:survey => @survey, :user_id => (@current_user.nil? ? @current_user : @current_user.id))
    @response_set.update_attribute(:user_state, params[:user_state])
    if (@survey && @response_set)
      flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(edit_my_survey_path(
        :survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.Unable_to_find_that_survey')
      redirect_to surveyor_index
    end
  end
  def show
    super
  end
  def edit
    super
  end
  def update
    super
  end

  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    #super # available_surveys_path
    root_url
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    #super # available_surveys_path
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods

  def get_current_user
    @current_user = self.respond_to?(:current_citizen) ? self.current_citizen : nil
  end


  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
