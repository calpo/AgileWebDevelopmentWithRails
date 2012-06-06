#encoding: utf-8

require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)


    # オンラインストアのインデックスページを訪れる
    get "/"
    assert_response :success
    assert_template "index"


    # 商品を選択してカートに入れる
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product


    # チェックアウトフォームに詳細を入力してチェックアウトする
    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders", order: {
      name:     "Dave Thomas",
      address:  "123 The Street",
      email:    "dave@example.com",
      pay_type: "現金"
    }
    assert_response :success
    assert_template "index"

    ## チェックアウトが成功するとカートの中身はからになる
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    ## オーダーにデータが登録される
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas",     order.name
    assert_equal "123 The Street",   order.address
    assert_equal "dave@example.com", order.email
    assert_equal "現金",            order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product


    # 注文の内容がメールで送信される
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam PHP <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
