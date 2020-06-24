# frozen_string_literal: true

# This class represent client for www.//www.petsonic.com.
class PensonicClient
  attr_reader :url_pattern
  attr_accessor :url

  def data
    links = category_goods
    p 'we are going to work with ' + links.length.to_s + ' goods'
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

  def add_result(goods_info, urls, responses)
    error_links = []
    urls.each do |url|
      goods_info.push(PensonicParser.parse_good(responses[url]))
    rescue StandardError
      p 'scarping error'
      p url
      error_links.push(url)
    end
    error_links
  end

  def scrape_goods_info(urls)
    goods_info = []
    responses = goods_info(urls)
    error_urls = add_result(goods_info, urls, responses)
    if (goods_info.length - error_urls.length) != goods_info.length
      p 'retry'
      responses1 = goods_info(error_urls)
      error_urls1 = add_result(goods_info, error_urls, responses1)
      unless error_urls1.empty?
        p 'urls not add '
        error_urls.each do |url|
          p url
        end
      end
    end
    p goods_info.length.to_s + ' is done'
    goods_info
  end
end
