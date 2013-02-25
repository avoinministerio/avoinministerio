class Document < ActiveRecord::Base
  attr_accessible :file, :idea_id, :file_name
  belongs_to :idea
  mount_uploader :file, InitiativeDocumentUploader

  def url
    
  end
end
