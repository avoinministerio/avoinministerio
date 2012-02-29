module Admin::PublishingActions
  def publish
    resource.publish!
    redirect_to :back
  end
  
  def unpublish
    resource.unpublish!
    redirect_to :back
  end
  
  def moderate
    resource.moderate!
    redirect_to :back
  end
end