class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.where(email: params[:email]).first
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_url, notice: '登录成功！'
    else
      flash.now[:alert] = '登录信息有误！'
      render :new
    end
  end

  def logout
    @current_user = session[:user_id] = nil
    redirect_to root_url, notice: '退出成功！'
  end

end
