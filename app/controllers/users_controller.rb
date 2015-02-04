class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to root_path, notice: '注册成功！'
    else
      flash.now[:alert] = '注册信息有误，请重试！'
      render :new
    end
  end

  def edit
  end

  def update
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
