require 'rails_helper'

feature 'creating comments' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }


  before do
    FactoryGirl.create(:state, name: 'Open')
    define_permission(user, :view, project)
    sign_in_as(user)
    visit '/'
    click_link project.name
    click_link ticket.title
  end


  scenario 'creating an comment' do
    fill_in 'Text', with: 'added a comment'
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')

    within('#comments') do
      expect(page).to have_content('added a comment')
    end
  end

  scenario 'creating an invalid comment' do
    click_button 'Create Comment'
    expect(page).to have_content('Comment has not been created')
    expect(page).to have_content("Text can't be blank")
  end

  scenario 'change ticket state' do
    fill_in 'Text', with: 'change a comment with state'
    select 'Open', from: 'State'
    click_button 'Create Comment'
    expect(page).to have_content('Comment has been created')

    within('#ticket .state') do
      expect(page).to have_content('Open')
    end
  end
end
