class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def delete_product (product_id)
    current_item = LineItem.find_by_product_id(product_id)
    if current_item.quantity > 1
      current_item.quantity -= 1
    else
      current_item.destroy
    end
  end

  def total_price
    product.price * quantity
  end
end
