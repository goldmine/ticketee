require 'rails_helper'

feature 'Creating Tickets' do

  before do
    @project = FactoryGirl.create(:project, name: "Internet Explorer")
    @user = FactoryGirl.create(:user)
    define_permission(@user, 'view', @project)
    define_permission(@user, 'create tickets', @project)
    define_permission(@user, 'tag', @project)
    sign_in_as(@user)
    visit '/'
    click_link @project.name
    click_link 'New Ticket'
  end

  scenario "can create a ticket" do
    fill_in 'Title', with: "Non-standards compliance"
    fill_in 'Description', with: 'My pages are ugly'
    click_button 'Create Ticket'
    expect(page).to have_content('Ticket was successfully created.')
    within "#ticket #author" do
      expect(page).to have_content("created by #{@user.email}")
    end
  end

  scenario "can not create a ticket without a name" do
    click_button 'Create Ticket'
    expect(page).to have_content("Ticket has not been created")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
  end 

  scenario "ticket title should more than 10 characters" do
    fill_in "Title", with: "more than 10 characters"
    fill_in "Description", with: "it sucks"
    click_button 'Create Ticket'

    expect(page).to have_content("Ticket has not been created")
    expect(page).to have_content("Description is too short")
  end

  scenario "Creating ticket with an attachment", js: true do
    fill_in "Title", with: "add document to ticket"
    fill_in "Description", with: "it sucks aaaaaaa"
    attach_file "File #1", Rails.root + "spec/fixtures/speed.txt"

    click_link "Add another file"
    attach_file "File #2", Rails.root + "spec/fixtures/speed1.txt"

    click_button 'Create Ticket'

    expect(page).to have_content("Ticket was successfully created")


    within("#ticket .assets") do
      expect(page).to have_content("speed.txt")
      expect(page).to have_content("speed1.txt")
    end
  end

  scenario "creating a ticket with tages" do
    fill_in "Title", with: "more than 10 characters"
    fill_in "Description", with: "it should able to add tags"
    fill_in "Tag names", with: "browser visual"
    click_button 'Create Ticket'

    expect(page).to have_content("Ticket was successfully created")
    within('#ticket #tags') do
      expect(page).to have_content("browser")
      expect(page).to have_content("visual")
    end
  end
end
