# frozen_string_literal: true

# This class represents goods from category.
class Goods
  attr_reader :product_main_name
  attr_reader :img
  attr_reader :weight_price

  def initialize(product_main_name, img)
    @product_main_name = product_main_name
    @img = img
    @weight_price = []
  end

  def add_weight_price(weight_price)
    @weight_price.push(weight_price)
  end
end
