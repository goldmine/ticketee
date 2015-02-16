class FilesController < ApplicationController
  before_action :require_signin!
  before_action :set_asset, only: :show
  before_action :authorize_view, only: :show

  def new
    @ticket = Ticket.new
    asset = @ticket.assets.build
    render partial: "files/form",
           locals: { number: params[:number].to_i } 
  end
  def show
    send_file @asset.asset.path,
              filename: @asset.asset_identifier,
              content_type: @asset.asset.content_type
  end

  private
  def set_asset
    @asset = Asset.find(params[:id])
  end
  def authorize_view
    if !current_user.admin? && cannot?("view".to_sym, @asset.ticket.project)
      redirect_to root_path, alert: 'The asset could not be found'
    end
  end
end
