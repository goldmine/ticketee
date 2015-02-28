class CommentsController < ApplicationController
  before_action :require_signin!
  before_action :set_ticket

  def create
    sanitize_parameters!
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user
    @names = params[:comment][:tag_names]
    if @names
      @names.split(" ").each do |name|
        @comment.ticket.tags << Tag.find_or_create_by(name: name)
      end
    end
    if @comment.save
      redirect_to [@project, @ticket], notice: 'Comment has been created'
    else
      flash[:alert] = 'Comment has not been created'
      @states = State.all
      render template: 'tickets/show'
    end
  end

  private
  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
    @project = @ticket.project
  end

  def comment_params
    params.require(:comment).permit(:text, :state_id)
  end

  def sanitize_parameters!
    if cannot?(:"change states", @ticket.project)
      params[:comment].delete(:state_id)
    end
    if cannot?(:tag, @ticket.project)
      params[:comment].delete(:tag_names)
    end
  end

end
