require 'rails_helper'

feature 'deleting tickets' do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project) }

  scenario 'deleting a ticket' do
    visit '/'
    click_link project.name
    click_link ticket.title
    click_link 'Delete Ticket'
    expect(page).to have_content("Ticket has been destroyed") 
    expect(page.current_url).to eq(project_url(project))
  end
end
