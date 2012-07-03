class ExportCitizens < BaseJob

  @queue = :export

  def self.perform()
    Citizen.export("2012-01-01")
  end
end