class CommentsController < ApplicationController
  before_action :require_signin!
  before_action :set_ticket

  def create
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user
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
    if cannot?(:"change states", @ticket.project)
      params.require(:comment).permit(:text)
    else
      params.require(:comment).permit(:text, :state_id)
    end
  end
end
