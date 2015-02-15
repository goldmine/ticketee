class FilesController < ApplicationController
  before_action :require_signin!
  before_action :set_asset
  before_action :authorize_view

  def show
    send_file @asset.asset.path,
              filename: @asset.asset_identifier,
              content_type: @asset.asset.content_type
  end

  private
  def authorize_view
    if !current_user.admin? && cannot?("view".to_sym, @asset.ticket.project)
      redirect_to root_path, alert: 'The asset could not be found'
    end
  end
  def set_asset
    @asset = Asset.find(params[:id])
  end
end
