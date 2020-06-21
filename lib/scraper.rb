# frozen_string_literal: true

# Interface of standart scraper
module Scraper
  def url
    raise 'Not implemented'
  end

  def run
    raise 'Not implemented'
  end
end
