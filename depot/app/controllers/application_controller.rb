class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_cart

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  def set_current_cart
    @current_cart = current_cart
  end
end
