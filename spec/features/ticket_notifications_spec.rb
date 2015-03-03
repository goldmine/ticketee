require 'rails_helper'

feature 'Ticket Notifications' do
  let!(:alice) {FactoryGirl.create(:user, email: "alice@example.com")}
  let!(:bob) {FactoryGirl.create(:user, email: "bob@example.com")}
  let!(:project) {FactoryGirl.create(:project, name: "Internet Explorer")}
  let!(:ticket) {FactoryGirl.create(:ticket, user: alice, project: project)}

  before do
    ActionMailer::Base.deliveries.clear
    define_permission(alice, 'view', project)
    define_permission(bob, 'view', project)
    sign_in_as(bob)
    visit '/'
  end

  scenario "ticket owner receivers notifications about comments" do
    click_link project.name
    click_link ticket.title
    fill_in 'comment_text', with: "Non-standards compliance"
    click_button 'Create Comment'

    email = find_email!(alice.email)
    subject = "[ticketee] #{project.name} - #{ticket.title}"

    expect(email.subject).to include(subject)
    click_first_link_in_email(email)
    within('#ticket h2') do
      expect(page).to have_content(ticket.title)
    end
  end

  scenario "comment authors are automaticlly subscribed a ticket" do
    click_link project.name
    click_link ticket.title
    fill_in 'comment_text', with: "bob's comment"
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')
    find_email!(alice.email)
    click_link "退出"

    reset_mailer
    sign_in_as(alice)
    click_link project.name
    click_link ticket.title
    fill_in "comment_text", with: "alice reply bob"
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')
    find_email!(bob.email)
    expect { find_email!(alice.email) }.to raise_error



  end

end
