require 'rails_helper'

feature 'Creating Tickets' do

  before do
    FactoryGirl.create(:project, name: "Internet Explorer")
    visit '/'
    click_link 'Internet Explorer'
    click_link 'New Ticket'
  end

  scenario "can create a ticket" do
    fill_in 'Title', with: "Non-standards compliance"
    fill_in 'Description', with: 'My pages are ugly'
    click_button 'Create Ticket'
    expect(page).to have_content('Ticket was successfully created.')
  end

  scenario "can not create a ticket without a name" do
    click_button 'Create Ticket'
    expect(page).to have_content("Ticket has not been created")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
  end 

end
