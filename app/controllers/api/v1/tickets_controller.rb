class Api::V1::TicketsController < Api::V1::BaseController
  before_action :find_project
  def index
    @tickets = @project.tickets
    respond_to do |format|
      format.json { render json: @tickets }
    end
  end

  private
  def find_project
    @project = Project.for(current_user).find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    error = { "error" => "The project could not be found" }
    render json: error.to_json, status: 404
  end
end
