# frozen_string_literal: true

class CSVFileWritter
  def initialize
    @data = []
    @file_name = ''
  end

  def setData(data, file_name)
    @data = data
    @file_name = file_name
  end

  def write
    goods = prepareData
    CSV.open('./' + @file_name + '.csv', 'w') do |csv|
      goods.each { |item| csv << item }
    end
    p @file_name
    p goods
  end

  private

  def prepareData
    result = []
    @data.each { |item| normalize(item).each { |value| result.push(value) } }
    result
  end

  def normalizeSingle(item)
    [[item.product_main_name, item.weight_price[0][0], item.img]]
  end

  def normalizeMult(item)
    name = item.product_main_name
    img = item.img
    result = []
    item.weight_price.each { |i| result.push([name + ' ' + i[1], i[0], img]) }
    result
  end

  def normalize(item)
    return normalizeMult(item) if item.weight_price.length > 1

    normalizeSingle(item)
  end
end
