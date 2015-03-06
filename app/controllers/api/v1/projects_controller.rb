class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @projects = Project.all
    respond_to do |format|
      format.json { render json: @projects }
    end
  end
end
