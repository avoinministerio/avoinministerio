class BootstrapTour < ActiveRecord::Base
  attr_accessible :action, :boolean, :controller, :integer, :integer, :is_ended, :step, :user_id
end
