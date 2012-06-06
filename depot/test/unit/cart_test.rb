#encoding: utf-8

require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :carts

  test "add_product productが既に登録されている場合は量が増える" do
    @cart = Cart.find 1
    @item = @cart.add_product 1
    assert_equal 2, @item.quantity
  end

  test "add_product productがまだ登録されていない場合は追加される" do
    @cart = Cart.new(id: 999999)

    @item = @cart.add_product 1
    assert_equal 1, @item.quantity
  end

  test "total_price カートが空の場合は0となる" do
    @cart = carts(:empty)
    assert_equal 0, @cart.total_price
  end

  test "total_price 複数種類個数の合計金額を取得する" do
    @cart = carts(:empty)
    @prod1 = products(:one)
    @prod2 = products(:two)

    @cart.add_product(@prod1.id).save!
    @cart.add_product(@prod1.id).save!
    @cart.add_product(@prod2.id).save!
    @total_price = (@prod1.price * 2) + @prod2.price

    assert_equal @total_price, @cart.total_price
  end
end
