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
      render template: 'tickets/show'
    end
  end

  private
  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
    @project = @ticket.project
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
