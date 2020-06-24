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

  def normalize(item)
    name = item.product_main_name
    img = item.img
    result = []
    item.measures_prices.each { |i| result.push([name + ' ' + i['measure'], i['price'], img]) }
    result
  end
end
