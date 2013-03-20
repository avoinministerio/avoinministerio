class Language < ActiveRecord::Base
  attr_accessible :name, :full_name

  def self.sorting_options
    @languages = []
    self.all.each do |language|
      @languages << [ language.name.to_sym, language.full_name ]
    end
    return @languages
  end

  def self.list
    @languages = Array.new
    self.all.each do |language|
      @languages << language.name.to_sym
    end
    return @languages
  end
end
