require 'rails_helper'

feature 'sina' do
  let!(:alice) { FactoryGirl.create(:user) }
  let!(:me) { FactoryGirl.create(:user, email: 'lugm_project@sina.com') }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: me) }

  before do
    ActionMailer::Base.delivery_method = :smtp
    define_permission(alice, "view", project)
    define_permission(me, "view", project)
  end

  scenario 'receiving real email' do
    sign_in_as(alice)
    visit project_ticket_path(project, ticket)
    fill_in 'comment_text', with: 'Posting a comment'
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')
    expect(ticketee_emails.count).to eql(1)
    email = ticketee_emails.first
    subject = "[ticketee] #{project.name} #{ticket.title}"
    expect(email.subject).to eql(subject)
    clear_ticketee_emails
  end

  after do
    ActionMailer::Base.delivery_method = :test
  end
end
