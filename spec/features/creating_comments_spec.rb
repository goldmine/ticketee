require 'rails_helper'

feature 'creating comments' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }


  before do
    FactoryGirl.create(:state, name: 'Open')
    define_permission(user, :view, project)
    define_permission(user2, :view, project)
    define_permission(user, :"change states", project)
  end


  scenario 'creating an comment' do
    sign_in_as(user)
    visit '/'
    click_link project.name
    click_link ticket.title
    fill_in 'Text', with: 'added a comment'
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')

    within('#comments') do
      expect(page).to have_content('added a comment')
    end
  end

  scenario 'creating an invalid comment' do
    sign_in_as(user)
    visit '/'
    click_link project.name
    click_link ticket.title
    click_button 'Create Comment'
    expect(page).to have_content('Comment has not been created')
    expect(page).to have_content("Text can't be blank")
  end

  scenario 'authorized user can change ticket state' do
    sign_in_as(user)
    visit '/'
    click_link project.name
    click_link ticket.title
    fill_in 'Text', with: 'change a comment with state'
    select 'Open', from: 'State'
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')

    within('#ticket .state') do
      expect(page).to have_content('Open')
    end
    within('#comments') do
      expect(page).to have_content('State: Open')
    end
  end

  scenario 'a user without permission cannot change the state' do
    sign_in_as(user2)
    visit '/'
    click_link project.name
    click_link ticket.title
    find_element = lambda { find("#comment_state_id") }
    message = "should not see #comment_state_id, but did see it"
    expect(find_element).to raise_error(Capybara::ElementNotFound), message
  end
end
