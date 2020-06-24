# frozen_string_literal: true

# This class represent client for www.//www.petsonic.com.
class PensonicClient
  attr_reader :url_pattern
  attr_accessor :url

  def data
    links = category_goods
    p links.length
    scrape_goods_info(links)
  end

  private

  def category_goods
    http = Curl.get(@url)
    if PensonicParser.category_with_sub?(http)
      links = PensonicParser.parse_single_category(http)
      Logger.log(links, 'get single category goods... ')
      return links
    end
    temp = []
    links = PensonicParser.parse_category_with_sub(http)
    i = 2
    loop  do
      url = @url + "?p=#{i}"
      http = Curl.get(url)
      temp = PensonicParser.parse_category_with_sub(http)
      break if temp.empty?
      temp.each do |item|
        links.push(item)
      end
      i += 1
    end
    Logger.log(links, 'get multi category goods... ')
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
      begin
        goods_info.push(PensonicParser.parse_good(responses[url]))
      rescue 
     end
    end
    p goods_info.length
    goods_info
  end
end
