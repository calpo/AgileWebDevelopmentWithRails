#encoding: utf-8

Order.transaction do
  (1..100).each do |i|
    Order.create(name: "Customer #{i}", address: "#{i} Main street",
        email: "cust-#{i}@example.com", pay_type: "現金" )
  end
end
