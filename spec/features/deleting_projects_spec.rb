require 'rails_helper'

feature 'admin user can deleting projects' do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:project) { FactoryGirl.create(:project) }

  scenario 'deleting a projects' do
    sign_in_as(admin)
    visit '/'
    click_link project.name
    click_link 'Delete Project'
    expect(page).to have_content("Project has been destroyed") 

    visit '/'
    expect(page).to have_no_content(project.name) 
  end
end
