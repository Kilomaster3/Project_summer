# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'curb'
require 'ostruct'
require 'csv'
require_relative './lib/logger'
require_relative './lib/personicparser'
require_relative './lib/goods'
require_relative './lib/personicclient'
require_relative './lib/csvfilewritter'
require_relative './lib/pensonicscraper'

# Main file of app
class Parser
  def initialize(scraper)
    @scraper = scraper
    @file_name_pattern = /^\w+$/
  end

  def run(arg_v)
    check_args(arg_v)
    @scraper.url(arg_v[0])
    @scraper.file_name = arg_v[1]
    @scraper.run
  end

  private

  def check_args(arg_v)
    raise 'You have to pass 2 args' if arg_v.length > 2
    raise 'arg_v[0] should be url' unless @scraper.url_pattern.match(arg_v[0])
    unless @file_name_pattern.match(arg_v[1].to_s)
      raise 'arg_v[1] should be file name, you can use letters, diggits or underscore'
    end
  end
end

parser = Parser.new(PensonicScraper.new(CSVFileWritter.new))
parser.run(ARGV)
