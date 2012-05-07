#encoding: utf-8

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product 内で title はユニークでなければならない" do
    product = new_product
    product.title = products(:ruby).title

    assert product.invalid?
    assert_equal "has already been taken", product.errors[:title].join('; ')

    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end

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
    product = new_product

    product.price = 0.01
    assert product.valid?

    product.price = 1
    assert product.valid?
  end

  test "image_url に不正なフォーマットのURLを設定できない" do
    bad = %w{ fred.txt fredjpg fred.jpg/more fred.jpg.more fred.jpg?more }

    product = new_product
    bad.each do |name|
      product.image_url = name
      assert product.invalid?, "#{name} は設定出来てはいけません"
    end
  end

  test "image_url に正しいフォーマットのURLを設定できる" do
    ok = %w{ fred.gif fred.jpg fred.png fred.GIF fred.JPG fred.PNG http://example.com/fred.jpg }

    product = new_product
    ok.each do |name|
      product.image_url = name
      assert product.valid?, "#{name} は設定出来なければなりません"
    end
  end

  def new_product
    Product.new(
      title:        "My Book Title",
      description:  "yyy",
      price:        1,
      image_url:    "zzz.jpg"
    )
  end

  def assert_invalid_price (price)
    product = new_product
    product.price = price

    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
  end
end
