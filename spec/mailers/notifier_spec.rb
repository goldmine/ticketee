require "rails_helper"

RSpec.describe Notifier, type: :mailer do
  context 'comment_updated' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:ticket_owner) { FactoryGirl.create(:user) }
    let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: ticket_owner) }
    let!(:comment_owner) { FactoryGirl.create(:user) }
    let!(:comment) do
      Comment.new({ text: 'it is wired',
                    user: comment_owner,
                    ticket: ticket })
    end
    let!(:email) do
      Notifier.comment_updated(comment, ticket_owner)
    end

    it 'sends out an email notification about a new comment' do
      expect(email.to).to include(ticket_owner.email)
      title = "#{ticket.title} for #{project.name} has been updated"
      expect(email.body).to include(title)
      expect(email.body).to include("#{comment_owner.email} wrote:")
      expect(email.body).to include(comment.text)
      expect(email.body).to have_content("it is wired")
    end

  end
end
