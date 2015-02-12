class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: '注册成功！'
    else
      flash.now[:alert] = '注册信息有误，请重试！'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: '更新成功！'
    else
      flash.now[:alert] = '更新信息有误，请重试！'
      render :edit
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  def set_user
    @user = User.find(params[:id])
  end
end
