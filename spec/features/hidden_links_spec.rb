require 'rails_helper'

feature "hidden links" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:project) { FactoryGirl.create(:project) }

  context "anonymous users" do
    scenario "can not see the new project link" do
      visit '/'
      expect(page).to_not have_link("New Project")
    end
    scenario "can not see the edit project link" do
      visit project_path(project) 
      expect(page).to_not have_link("Edit Project")
    end
    scenario "can not see the delete project link" do
      visit project_path(project) 
      expect(page).to_not have_link("Delete Project")
    end
  end

  context "reqular user" do
    before { sign_in_as(user) }
    scenario "can not see the new project link" do
      visit '/'
      expect(page).to_not have_link("New Project")
    end
    scenario "can not see the edit project link" do
      visit project_path(project)
      expect(page).to_not have_link("Edit Project")
    end
    scenario "can not see the delete project link" do
      visit project_path(project)
      expect(page).to_not have_link("Delete Project")
    end
  end

  context "admin user" do
    before { sign_in_as(admin) }
    scenario "can see the new project link" do
      visit '/'
      expect(page).to have_link("New Project")
    end
    scenario "can see the edit project link" do
      visit project_path(project)
      expect(page).to have_link("Edit Project")
    end
    scenario "can see the delete project link" do
      visit project_path(project)
      expect(page).to have_link("Delete Project")
    end
  end

end
