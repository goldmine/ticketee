class Api::V1::BaseController < ActionController::Base
  before_filter :authenticate_user

  private
  def authenticate_user
    @current_user = User.find_by_auth_token(params[:token])
    if !@current_user 
      respond_to do |format|
        format.json { render json: { error: "token is invalid" } }
      end
    end
  end

  def current_user
    @current_user
  end
end
