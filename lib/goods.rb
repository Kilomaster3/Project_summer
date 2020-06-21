# frozen_string_literal: true

# This class represents goods from category.
class Goods
  attr_reader :product_main_name
  attr_reader :img
  attr_reader :measures_prices

  def initialize(product_main_name, img)
    @product_main_name = product_main_name
    @img = img
    @measures_prices = []
  end

  def add_measure_price(measure_price)
    @measures_prices.push(measure_price)
  end
end
