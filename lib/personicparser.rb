# frozen_string_literal: true

# This class represents parser for goods and category from www.//www.petsonic.com
class PensonicParser
  def self.parse_category_goods(http)
    doc = Nokogiri::HTML(http.body_str)
    links = []
    doc.xpath('//link[@itemprop = "url"]').each { |row| links.push(row['href']) }
    links
  end

  def self.parse_good(http)
    doc = Nokogiri::HTML(http.body_str)
    good_name = doc.xpath('//h1[@class = "product_main_name"]').text
    img =  doc.xpath('//img[@id = "bigpic"]')[0]['src']
    good = Goods.new(good_name, img)
    doc.xpath('//ul[@class = "attribute_radio_list"]/li').each do |row|
      inner_html = Nokogiri::HTML(row.inner_html)
      weight_price = inner_html.xpath('//span[@class = "price_comb"]', '//span[@class = "radio_label"]')
      good.add_weight_price([weight_price[0].text, weight_price[1].text])
    end
    good
  end
end
