require 'rails_helper'

feature 'watching tickets' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project,
                                       user: user) }
  before do
    define_permission(user, "view", project)
    sign_in_as(user)
    visit '/'
  end

  scenario 'ticket watching toggling' do
    click_link project.name
    click_link ticket.title
    within('#watchers') do
      expect(page).to have_content(user.email)
    end

    click_button 'Stop watching this ticket'
    expect(page).to have_content('You are no longer watching this ticket')
    within('#watchers') do
      expect(page).to_not have_content(user.email)
    end

    click_button 'Watch this ticket'
    expect(page).to have_content('You are now watching this ticket')
    within('#watchers') do
      expect(page).to have_content(user.email)
    end
  end
end
