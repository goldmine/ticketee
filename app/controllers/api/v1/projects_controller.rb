class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    @projects = Project.for(current_user).all
    respond_to do |format|
      format.json { render json: @projects }
    end
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      respond_to do |format|
        format.json { render json: @project, location: api_v1_project_path(@project) }
      end
    else
      render json: @project.errors
    end
  end

  private
  def project_params
    params.require(:project).permit(:name)
  end
end
