class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.where(email: params[:email]).first
    if @user && @user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      redirect_to root_url, notice: '登录成功！'
    else
      flash.now[:alert] = '登录信息有误！'
      render :new
    end
  end

  def logout
    cookies.delete(:auth_token)
    @current_user =  nil
    redirect_to root_url, notice: '退出成功！'
  end

end
