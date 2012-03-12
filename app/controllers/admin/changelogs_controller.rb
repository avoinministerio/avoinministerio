require 'differ/string'

class Admin::ChangelogsController < Admin::AdminController
  respond_to :html

  def index
    @changelogs = Changelog.paginate(page: params[:page]).order('created_at DESC')
    respond_with @changelogs
  end
end
