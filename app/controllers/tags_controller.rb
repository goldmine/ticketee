class TagsController < ApplicationController
  before_action :authorize_remove

  def remove
    @tag = Tag.find(params[:id])
    @ticket.tags -= [@tag]
    @ticket.save!
    respond_to do |format|
      format.js {}
    end
  end

  private
  def authorize_remove
    @ticket = Ticket.find(params[:ticket_id])
    if !current_user.admin? && cannot?("tag".to_sym, @project)
      redirect_to [@ticket.project, @ticket], alert: 'you do not have permission!'
    end
  end
end
