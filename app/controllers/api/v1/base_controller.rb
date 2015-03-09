class Api::V1::BaseController < ActionController::Base
  before_action :authenticate_user, :check_rate_limit

  private
  def authenticate_user
    @current_user = User.find_by_auth_token(params[:token])
    if !@current_user 
      respond_to do |format|
        format.json { render json: { error: "token is invalid" } }
      end
    end
  end

  def check_rate_limit
    if @current_user.request_count > 100
      render json: { error: "Rate limit exceeded" }, status: 403
    else
      @current_user.increment!(:request_count)
    end
  end

  def current_user
    @current_user
  end
end
