require 'spec_helper'

describe Admin::ChangelogsController do

  before :each do
    @administrator = Factory(:administrator)
    sign_in :administrator, @administrator
  end

  describe "GET 'index'" do
    render_views

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "shows changelogs" do
      idea = Factory(:idea, :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
      idea.title = "Lorem ipsum dolor sit amet, ..."
      idea.save

      get 'index'

      assigns(:changelogs).size.should be == 2
    end

    it "shows short diffs" do
      idea = Factory :idea, :body => <<-EOS
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat.
EOS
      idea.body = <<-EOS
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Lorem ipsum dolor sit amet, consectetur adipisicing elit.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat.
EOS
      idea.save

      get 'index'

      assigns(:changelogs).size.should be == 2

      chars_around = Admin::ChangelogsHelper::CHARACTERS_AROUND_DIFF
      response.body.should =~ /&hellip; (.|\n){#{chars_around}}<ins class="differ">Lorem ipsum dolor sit amet, consectetur adipisicing elit.\n<\/ins>(.|\n){#{chars_around}} &hellip;/
    end
  end

end
