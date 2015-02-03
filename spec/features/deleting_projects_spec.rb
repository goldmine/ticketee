require 'rails_helper'

feature 'deleting projects' do
  scenario 'deleting a projects' do
    FactoryGirl.create(:project, name: "TextMate 2")
    visit '/'
    click_link 'Delete Project'
    expect(page).to have_content("Project has been destroyed") 

    visit '/'
    expect(page).to have_no_content("TextMate 2") 
  end
end
