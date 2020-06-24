# frozen_string_literal: true

require_relative './filewritter'
# This class represents writter to csv file.
class CSVFileWritter
  include FileWritter
  def set_data(data, file_name)
    @data = data
    @file_name = file_name
  end

  def write
    goods = prepare_data
    CSV.open('./' + @file_name + '.csv', 'w') do |csv|
      goods.each { |item| csv << item }
    end
    p @file_name
    p goods
  end

  private

  def prepare_data
    result = []
    @data.each { |item| normalize(item).each { |value| result.push(value) } }
    result
  end

  def normalize_single(item)
    if item.measures_prices[0].nil?
      return [[item.product_main_name,'non', item.img]]
    end
    [[item.product_main_name, item.measures_prices[0]['price'], item.img]]
  end

  def normalize_mult(item)
    name = item.product_main_name
    img = item.img
    result = []
    item.measures_prices.each { |i| result.push([name + ' ' + i['measure'], i['price'], img]) }
    result
  end

  def normalize(item)
    return normalize_mult(item) if item.measures_prices.length > 1

    normalize_single(item)
  end
end
