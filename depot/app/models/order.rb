#encoding: utf-8

class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "現金", "クレジットカード", "注文書" ]
end
