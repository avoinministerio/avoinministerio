module Admin::PublishingActions
  def publish
    resource.publish!
    redirect_to :back
  end
  
  def unpublish
    resource.respond_to?(:prepare_for_unpublishing) and resource.prepare_for_unpublishing
    resource.unpublish!
    redirect_to :back
  end
  
  def moderate
    resource.respond_to?(:prepare_for_unpublishing) and resource.prepare_for_unpublishing
    resource.moderate!
    redirect_to :back
  end
end