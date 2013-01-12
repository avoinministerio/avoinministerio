class Array
  def randomize
    duplicated_original, new_array = self.dup, self.class.new
    new_array << 
    duplicated_original.slice!(rand(duplicated_original.size)) until new_array.size.eql?(self.size)
    new_array
  end
  
  def randomize!
    self.replace(randomize)
  end
end