# frozen_string_literal: true

# This class represents parser for goods and category from www.//www.petsonic.com
class PensonicParser
  def self.parse_single_category(http)
    doc = Nokogiri::HTML(http.body_str)
    links = []
    doc.xpath('//link[@itemprop = "url"]').each { |row| links.push(row['href']) }
    links
  end

  def self.category_with_sub?(http)
    doc = Nokogiri::HTML(http.body_str)
    id = doc.xpath('//div[@id = "subcategories"]')
    id.empty?
  end

  def self.parse_category_with_sub(http)
    doc = Nokogiri::HTML(http.body_str)
    links = []
    doc.xpath('//a[@class = "product_img_link pro_img_hover_scale product-list-category-img"]')
       .each { |row| links.push(row['href']) }
    links
end

  def self.parse_good(http)
    doc = Nokogiri::HTML(http.body_str)
    good_name = doc.xpath('//h1[@class = "product_main_name"]').text
    img = " "
    img_temp = doc.xpath('//img[@id = "bigpic"]')[0]
    if !img_temp.nil?
      img = img_temp['src']
    end

    good = Goods.new(good_name, img)
     
    doc.xpath('//ul[@class = "attribute_radio_list"]/li').each do |row|
      inner_html = Nokogiri::HTML(row.inner_html)
      goods_info = inner_html.xpath('//span[@class = "price_comb"]', '//span[@class = "radio_label"]')
      good.add_measure_price({ 'price' => remove_symbol(goods_info[0].text), 'measure' => goods_info[1].text })
    end
    good
  end

  private 

  def self.remove_symbol(cur)
    pattern = /(\d+\.?\d*)(.+)/
    temp = pattern.match(cur)
    temp[1]
  end

end
