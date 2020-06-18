# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'curb'
require 'ostruct'
require './logger'
require './personicparser'
require './goods'

# $url_pattern = %r{^(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?$}

class PensonicScraper
  attr_reader :url_pattern

  def initialize
    @url_pattern = %r{^(https?://)?(www\.petsonic\.com)([/\w \.-]*)*/?$}
  end

  def get_category_goods(url)
    http = Curl.get(url)
    links = PensonicParser.parse_category_goods(http)
    Logger.log(links, 'get category goods... ')
    links
  end

  def get_good_info(url)
    http = Curl.get(url)
    doc = Nokogiri::HTML(http.body_str)
    good_name = doc.xpath('//h1[@class = "product_main_name"]').text
    img =  doc.xpath('//img[@id = "bigpic"]')[0]['src']
    good = Goods.new(good_name, img)
    doc.xpath('//ul[@class = "attribute_radio_list"]/li').each do |row|
      temp1 = Nokogiri::HTML(row.inner_html)
      weight_price = temp1.xpath('//span[@class = "price_comb"]', '//span[@class = "radio_label"]')
      good.add_weight_price([weight_price[0].text, weight_price[1].text])
    end
    p good
  end

  def scrape_goods_info(links)
    links.each { |link| get_good_info(link) }
  end

  def parse(url)
    links = get_category_goods(url)
    scrape_goods_info(links)
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

  def parse
    @site_parser.parse(@url)
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
parser.parse
