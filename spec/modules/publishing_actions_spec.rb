require 'spec_helper'

describe Admin::PublishingActions do
  class PublishingController
    attr_accessor :resource
    
    def resource
      @resource ||= PublishingClass.new
    end
    
    def redirect_to(target)
      true
    end
  end
  
  class PublishingClass
    attr_accessor :message
    
    def publish!
      @message = "published"
    end
    
    def unpublish!
      @message = "unpublished"
    end
    
    def moderate!
      @message = "moderated"
    end
  end
  
  before(:each) do
    @klass = PublishingController.new
    @klass.extend(Admin::PublishingActions)
  end
  
  it "responds to publish" do
    @klass.should respond_to :publish
  end

  it "responds to unpublish" do
    @klass.should respond_to :unpublish
  end
  
  it "responds to moderate" do
    @klass.should respond_to :moderate
  end
  
  it "publishes stuff" do
    @klass.publish.should be_true
    @klass.resource.message.should == "published"
  end
  
  it "unpublishes stuff" do
    @klass.unpublish.should be_true
    @klass.resource.message.should == "unpublished"
  end
  
  it "moderates stuff" do
    @klass.moderate.should be_true
    @klass.resource.message.should == "moderated"
  end
end