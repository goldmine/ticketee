require 'rails_helper'

feature 'Editing Tickets' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }

  before do
    sign_in_as(user)
    visit '/'
    click_link project.name 
    click_link ticket.title 
    click_link "Edit Ticket"
  end

  scenario "Updating a ticket" do
    fill_in 'Title', with: "Make it really shiny!"
    click_button 'Update Ticket'
    expect(page).to have_content('Ticket was successfully updated')

    within("#ticket h2") do
      expect(page).to have_content('Make it really shiny!')
    end
  end

  scenario "updating with invalid data is bad" do
    fill_in 'Title', with: ""
    click_button 'Update Ticket'
    expect(page).to have_content('Ticket has not been updated')
  end

end
