# frozen_string_literal: true

class PensonicParser
  def self.parse_category_goods(http)
    doc = Nokogiri::HTML(http.body_str)
    links = []
    doc.xpath('//link[@itemprop = "url"]').each { |row| links.push(row['href']) }
    links
  end
end
