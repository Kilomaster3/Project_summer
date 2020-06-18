# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'curb'
require 'ostruct'
require './logger'
require './personicparser'
require './goods'
require './personicclient'

# $url_pattern = %r{^(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?$}

class PensonicScraper
	def initialize
    @url_pattern = %r{^(https?://)?(www\.petsonic\.com)([/\w \.-]*)*/?$}
    @petsonic_client = PensonicClient.new()
  end

  def url_pattern
  	@url_pattern 
  end

  def set_url(url)
  	@petsonic_client.set_url(url)
 end

 def run
	data = @petsonic_client.data
	p data
 end
end

class CSVFileWritter
	def Normalize
		normalaizer = 
	end
end

class Program
  def initialize(site_parser)
    @site_parser = site_parser
    @url = ''
    @file_path = ''
    @file_name_path = /^\w+$/
  end

  def set_arg(arg_v)
    check_args(arg_v)
    @url = arg_v[0]
    @file_path = arg_v[1]
    puts @url
    puts @file_path
  end

  def data
    @site_parser.set_url(@url)
    @site_parser.run
  end

  private

  def check_args(arg_v)
    raise 'You have to pass 2 args' if arg_v.length > 2
    raise 'arg_v[0] should be url' unless @site_parser.url_pattern.match(arg_v[0])
    unless @file_name_path.match(arg_v[1].to_s)
      raise 'arg_v[1] should be file name, you can use letters, diggits or underscore'
    end
  end
end

parser = Program.new(PensonicScraper.new)
parser.set_arg(ARGV)
parser.data
