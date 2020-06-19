# frozen_string_literal: true

# This class represents writter to csv file.
class CSVFileWritter
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
    [[item.product_main_name, item.weight_price[0][0], item.img]]
  end

  def normalize_mult(item)
    name = item.product_main_name
    img = item.img
    result = []
    item.weight_price.each { |i| result.push([name + ' ' + i[1], i[0], img]) }
    result
  end

  def normalize(item)
    return normalize_mult(item) if item.weight_price.length > 1

    normalize_single(item)
  end
end
