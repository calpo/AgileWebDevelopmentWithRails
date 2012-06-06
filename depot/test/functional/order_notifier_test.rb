require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
  @order = orders(:two)

    mail = OrderNotifier.received(orders(:two))
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ["jhon@example.org"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:two))
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ["jhon@example.org"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match /<td>Programming Ruby 1.9 \(\$49.00\)<\/td>/,
      mail.body.encoded
  end

end
