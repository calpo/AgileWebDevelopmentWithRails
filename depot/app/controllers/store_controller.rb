class StoreController < ApplicationController
  skip_before_filter :authorize

  def index
    @products = Product.order(:title)
    @cart = current_cart

    session[:counter] ||= 0
    @count = session[:counter] += 1
  end

end
