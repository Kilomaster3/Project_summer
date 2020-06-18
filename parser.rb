# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'curb'
require 'ostruct'
require 'csv'
require './lib/logger'
require './lib/personicparser'
require './lib/goods'
require './lib/personicclient'
require './lib/csvfilewritter'
require './lib/pensonicscraper'

class Program
  def initialize(scraper)
    @scraper = scraper
    @url = ''
    @file_name = ''
    @file_name_path = /^\w+$/
  end

  def setArg(arg_v)
    check_args(arg_v)
    @url = arg_v[0]
    @file_name = arg_v[1]
  end

  def run
    @scraper.set_url(@url)
    @scraper.setFileName(@file_name)
    @scraper.run
  end

  private

  def check_args(arg_v)
    raise 'You have to pass 2 args' if arg_v.length > 2
    raise 'arg_v[0] should be url' unless @scraper.url_pattern.match(arg_v[0])
    unless @file_name_path.match(arg_v[1].to_s)
      raise 'arg_v[1] should be file name, you can use letters, diggits or underscore'
    end
  end
end
parser = Program.new(PensonicScraper.new)
parser.setArg(ARGV)
parser.run
