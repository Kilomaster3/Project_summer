# frozen_string_literal: true

# This class represent client for www.//www.petsonic.com.
class PensonicClient
  attr_reader :url_pattern
  attr_accessor :url

  def data
    links = category_goods
    scrape_goods_info(links)
  end

  private

  def category_goods
    http = Curl.get(@url)
    links = PensonicParser.parse_category_goods(http)
    Logger.log(links, 'get category goods... ')
    links
  end

  def goods_info(urls)
    responses = {}
    m = Curl::Multi.new
    urls.each do |url|
      responses[url] = Curl::Easy.new(url)
      m.add(responses[url])
    end
    m.perform
    Logger.log_request_time(urls, responses)
    responses
  end

  def scrape_goods_info(urls)
    goods_info = []
    responses = goods_info(urls)
    urls.each do |url|
      goods_info.push(PensonicParser.parse_good(responses[url]))
    end
    goods_info
  end
end
