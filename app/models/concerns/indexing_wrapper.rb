class Concerns::IndexingWrapper
  def after_save(record)
    begin
      record.send :update_tank_indexes
    rescue IndexTank::HttpCodeException => e
      Rails.logger.warn "Failed to index a document: #{e.message}"
    end
  end
  
  def after_destroy(record)
    begin
      record.send :delete_tank_indexes
    rescue IndexTank::HttpCodeException => e
      Rails.logger.warn "Failed to delete document from index: #{e.message}"
    end
  end
end
