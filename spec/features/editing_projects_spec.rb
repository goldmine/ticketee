require 'rails_helper'

feature 'Editing Projects' do
  before do
    FactoryGirl.create(:project, name: 'TextMate 2')
    sign_in_as(FactoryGirl.create(:admin_user))
    visit '/'
    click_link 'TextMate 2'
    click_link 'Edit Project'
  end

  scenario "can edit a project" do
    fill_in 'Name', with: "TextMate 2 beta"
    click_button 'Update Project'
    expect(page).to have_content('Project was successfully updated.')
  end

  scenario "updating with invalid data is bad" do
    fill_in 'Name', with: ""
    click_button 'Update Project'
    expect(page).to have_content('Project has not been updated')
  end

end
