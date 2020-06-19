# frozen_string_literal: true

# This class represent scraper for www.//www.petsonic.com.
class PensonicScraper
  attr_accessor :file_name
  attr_reader :url_pattern

  def initialize(file_writter)
    @url_pattern = %r{^(https?://)?(www\.petsonic\.com)([/\w \.-]*)*/?$}
    @file_name = 'a.csv'
    @petsonic_client = PensonicClient.new
    @file_writter = file_writter
  end

  def url(url)
    @petsonic_client.url = url
  end

  def run
    p 'getting data: '
    data = @petsonic_client.data
    @file_writter.set_data(data, @file_name)
    p 'writting file '
    @file_writter.write
  end
end
