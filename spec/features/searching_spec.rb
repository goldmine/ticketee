require 'rails_helper'

feature 'searching tags' do
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
    fill_in 'Title', with: 'ticket-1'
    fill_in 'Description', with: 'ticket with tag name for del'
    fill_in 'Tag names', with: 'ticket1'
    click_button 'Create Ticket'
    visit '/'
    click_link project.name
    click_link 'New Ticket'
    fill_in 'Title', with: 'ticket-2'
    fill_in 'Description', with: 'ticket with tag name for del'
    fill_in 'Tag names', with: 'ticket2'
    click_button 'Create Ticket'
  end

  scenario 'finding by tag' do
    visit '/'
    click_link project.name
    expect(page).to have_content('ticket-1')
    expect(page).to have_content('ticket-2')

    fill_in 'Search', with: 'ticket1'
    click_button 'Search'

    within('#tickets') do
      expect(page).to have_content('ticket-1')
      expect(page).to_not have_content('ticket-2')
    end
  end

end
