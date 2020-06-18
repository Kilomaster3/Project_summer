# frozen_string_literal: true

class Goods
  def initialize(product_main_name, img)
    @product_main_name = product_main_name
    @img = img
    @weight_price = []
  end

  attr_reader :weight_price

  def add_weight_price(weight_price)
    @weight_price.push(weight_price)
  end
end
