#encoding: utf-8

require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "add_product productが既に登録されている場合は量が増える" do
    @cart = Cart.find 1
    @item = @cart.add_product 1
    assert_equal 2, @item.quantity
  end

  test "add_product productがまだ登録されていない場合は追加される" do
    @cart = Cart.new(id: 99999)

    # テストの前提条件 line_itemsの登録が無いことを念のため確認
    assert_equal 0, @cart.line_items.count

    @item = @cart.add_product 1
    assert_equal 1, @item.quantity
  end
end
