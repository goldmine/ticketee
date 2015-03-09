class Api::V1::ProjectsController < Api::V1::BaseController
  before_action :authorize_admin, only: :create
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

  def show
    @project = Project.find(params[:id])
    render json: @project, methods: "last_ticket"
  end

  private
  def project_params
    params.require(:project).permit(:name)
  end
  def authorize_admin
    if !@current_user.admin?
      error = { "error" => "You must be an admin to do that" }
      render json: error.to_json, status: 401
    end
  end
end
