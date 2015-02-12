require 'rails_helper'

feature 'viewing projects' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:project2) { FactoryGirl.create(:project, name: 'Hidden') }

  before do
    sign_in_as(user)
    define_permission(user, :view, project)
  end

  scenario 'listing authorized projects' do
    visit '/'
    expect(page).to_not have_content(project2.name)
    click_link project.name
    expect(page.current_url).to eql(project_url(project))
  end
end
