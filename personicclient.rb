class PensonicClient
  attr_reader :url_pattern

  def initialize
    @url = ''
  end

  def set_url(url)
    @url = url 

  end

  def data
    links = get_category_goods
    scrape_goods_info(links)
  end

  private

  def get_category_goods
    http = Curl.get(@url)
    links = PensonicParser.parse_category_goods(http)
    Logger.log(links, 'get category goods... ')
    links
  end

  def get_good_info(url)
    http = Curl.get(url)
    good = PensonicParser.parse_good(http)
    good
  end

  def scrape_goods_info(links)
    goods_info = []
    links.each { |link| goods_info.push(get_good_info(link)) }
    goods_info
  end
end