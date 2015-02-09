class ProjectsController < ApplicationController
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
      if @project.save
        redirect_to @project, notice: 'Project was successfully created.'
      else
        flash.now[:alert] = "Project has not been created"
        render :new
      end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
      if @project.update(project_params)
        redirect_to @project, notice: 'Project was successfully updated.'
      else
        flash.now[:alert] = "Project has not been updated"
        render :edit
      end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project has been destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project could not be found"
      redirect_to projects_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description)
    end

    def require_admin!
      require_signin!
      unless current_user.admin?
        redirect_to root_url, alert: "你没有权限执行！"
      end
    end
end
