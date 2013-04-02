module Concerns::IndexingWrapperTest
  module ClassMethods
    def after_save(record)
      true
    end

    def after_destroy(record)
      true
    end
  end

  def included(sender)
    sender.extend(ClassMethods)
  end

end
