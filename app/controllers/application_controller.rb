class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :require_signin!

  private
  def require_signin!
    if current_user.nil?
      redirect_to new_session_path, alert: '必须先登录！'
    end
  end

  def current_user
    @current_user || User.find(session[:user_id]) if session[:user_id]
  end

end
