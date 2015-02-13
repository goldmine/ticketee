require 'rails_helper'

feature 'deleting tickets' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, user: user, project: project) }
  before do
    define_permission(user, 'view', project)
    define_permission(user, 'delete ticket', project)
  end

  scenario 'deleting a ticket' do
    sign_in_as(user)
    visit '/'
    click_link project.name
    click_link ticket.title
    click_link 'Delete Ticket'
    expect(page).to have_content("Ticket has been destroyed") 
    expect(page.current_url).to eq(project_url(project))
  end
end
