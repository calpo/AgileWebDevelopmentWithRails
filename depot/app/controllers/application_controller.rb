#encoding: utf-8

class ApplicationController < ActionController::Base
  before_filter :authorize

  protect_from_forgery

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: "ログインしてください"
    end
  end
end
