require 'rails_helper'

feature 'seed data' do
  scenario 'the basic' do
    load Rails.root + "db/seeds.rb"
    user = User.where(email: "admin@example.com").first!
    project = Project.where(name: "Ticketee Beta").first!
    visit new_session_path
    fill_in '邮箱', with: user.email
    fill_in '密码', with: 'password'
    click_button '提交'
    click_link "Ticketee Beta"
    click_link "New Ticket"
    fill_in "Title", with: "comments with state" 
    fill_in "Description", with: "always has a state" 
    click_button "Create Ticket"

    within('#comment_state_id') do
      expect(page).to have_content('New')
      expect(page).to have_content('Open')
      expect(page).to have_content('Closed')
    end

  end
end
