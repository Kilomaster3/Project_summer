# frozen_string_literal: true

class PensonicScraper
  def initialize
    @url_pattern = %r{^(https?://)?(www\.petsonic\.com)([/\w \.-]*)*/?$}
    @file_name = 'a.csv'
    @petsonic_client = PensonicClient.new
  end

  attr_reader :url_pattern

  def set_url(url)
    @petsonic_client.set_url(url)
  end

  def setFileName(file_name)
    @file_name = file_name
  end

  def run
    data = @petsonic_client.data
    csvfilewritter = CSVFileWritter.new
    csvfilewritter.setData(data, @file_name)
    csvfilewritter.write
  end
end
