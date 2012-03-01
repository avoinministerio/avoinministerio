module Admin::AdminHelper
  def classes_for_nav(object)
    "active" if controller_name == object
  end
end