require 'rails_helper'

feature 'deleting tags' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }

  before do
    sign_in_as(user)
    define_permission(user, "view", project)
    define_permission(user, "create tickets", project)
    define_permission(user, "tag", project)
    visit '/'
    click_link project.name
    click_link 'New Ticket'
    fill_in 'Title', with: 'ticket with tag'
    fill_in 'Description', with: 'ticket with tag name for del'
    fill_in 'Tag names', with: 'one two'
    click_button 'Create Ticket'
  end

  scenario 'it should have a ticket with tag' do
    expect(page).to have_content('ticket with tag')
    within('#ticket #tags') do
      expect(page).to have_content('one')
    end
  end

  scenario 'deleting a tag', js:true  do
    click_link "delete-one"
    within('#ticket #tags') do
      expect(page).to_not have_content('one')
      expect(page).to have_content('two')
    end
  end
end
