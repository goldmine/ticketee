class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(:email)
  end
  def new
    @user = User.new
  end

  def show

  end

  def create
    @user = User.new(user_params)
    @user.password_confirmation = params[:password]
    if @user.save
      redirect_to admin_users_path, notice: 'User has been created'
    else
      flash.now[:alert] = 'User has not been created'
      render :new
    end
  end

  def edit
    
  end

  def update
    param = user_params
    if param[:password].blank?
      param.delete(:password)
      param.delete(:password_confirmation)
    end
    if @user.update_attributes(param)
      redirect_to admin_users_path, notice: 'User has been updated'
    else
      flash.now[:alert] = 'User has not been updated'
      render :edit
    end

  end

  

  private

  def user_params
    params.require(:user).permit(:email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
