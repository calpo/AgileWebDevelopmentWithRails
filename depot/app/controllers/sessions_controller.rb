#encoding: utf-8

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "ユーザーもしくはパスワードが無効です"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: "ログアウト"
  end

end
