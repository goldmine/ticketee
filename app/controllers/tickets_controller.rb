class TicketsController < ApplicationController
  before_action :require_signin!
  before_action :set_project
  before_action :set_ticket, only:[:watch, :show, :edit, :update, :destroy] 
  before_action :authorize_create, only:[:new, :create]
  before_action :authorize_edit, only:[:edit, :update]
  before_action :authorize_delete, only: :destroy

  def new
    @ticket = @project.tickets.build
    @ticket.assets.build
  end

  def create
    sanitize_parameters!
    @ticket = @project.tickets.build(ticket_params)
    @ticket.user = current_user
    @names = params[:ticket][:tag_names]
    if @names
      @names.split(" ").each do |name|
        @ticket.tags << Tag.find_or_create_by(name: name)
      end
    end

    if @ticket.save
      redirect_to [@project, @ticket], notice: "Ticket was successfully created."
    else
      flash.now[:alert] = "Ticket has not been created"
      render 'new'
    end
  end

  def show
    @comment = @ticket.comments.build
    @states = State.all
  end

  def search
    @tickets = @project.tickets.search("tag:#{params[:Search]}")
    render 'projects/show'
  end

  def edit
  end

  def update
    if @ticket.update_attributes(ticket_params)
      redirect_to [@project, @ticket], notice: "Ticket was successfully updated"
    else
      flash.now[:alert] = "Ticket has not been updated"
      render 'edit'
    end
  end

  def destroy
    @ticket.destroy
    redirect_to @project, notice: "Ticket has been destroyed"
  end

  def watch
    if @ticket.watchers.include?(current_user)
      @ticket.watchers -= [current_user]
      flash[:notice] = 'You are no longer watching this ticket'
    else
      @ticket.watchers += [current_user]
      flash[:notice] = 'You are now watching this ticket'
    end
    redirect_to [@project, @ticket]

  end

  private
  def set_project
    @project = Project.for(current_user).find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'The project could not be found'
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :asset, assets_attributes: [:asset])
  end
  
  def authorize_create
    if !current_user.admin? && cannot?("create tickets".to_sym, @project)
      redirect_to @project, alert: 'you do not have permission!'
    end
  end
  def authorize_edit
    if !current_user.admin? && cannot?("edit ticket".to_sym, @project)
      redirect_to @project, alert: 'you do not have permission!'
    end
  end
  def authorize_delete
    if !current_user.admin? && cannot?("delete ticket".to_sym, @project)
      redirect_to @sanproject, alert: 'you do not have permission!'
    end
  end
  def sanitize_parameters!
    if !current_user.admin? && cannot?("tag".to_sym, @project)
      params[:ticket].delete(:tag_names)
    end
  end
end
