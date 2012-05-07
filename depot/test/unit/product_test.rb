#encoding: utf-8

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product の属性の値に空は許されない" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "価格に負の値は設定できない" do
    assert_invalid_price -1
    assert_invalid_price -0.009
  end

  test "価格に0.01未満は設定できない" do
    assert_invalid_price 0
    assert_invalid_price 0.009
  end

  test "価格に正の値を設定できる" do
    product = get_product

    product.price = 0.01
    assert product.valid?

    product.price = 1
    assert product.valid?
  end

  def get_product
    Product.new(
      title:        "My Book Title",
      description:  "yyy",
      image_url:    "zzz.jpg"
    )
  end

  def assert_invalid_price (price)
    product = get_product
    product.price = price

    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
  end
end
