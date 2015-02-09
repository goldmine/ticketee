require 'rails_helper'

feature 'admin user can deleting projects' do
  let(:admin) { FactoryGirl.create(:admin_user) }
  scenario 'deleting a projects' do
    FactoryGirl.create(:project, name: "TextMate 2")
    sign_in_as(admin)
    visit '/'
    click_link 'Delete Project'
    expect(page).to have_content("Project has been destroyed") 

    visit '/'
    expect(page).to have_no_content("TextMate 2") 
  end
end
