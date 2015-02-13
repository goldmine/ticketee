require 'rails_helper'

feature "hidden links" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }

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
    scenario "New ticket link is shown to a user with permission" do
      define_permission(user,'view', project)
      define_permission(user,'create', project)
      visit project_path(project)
      expect(page).to have_link("New Ticket")
    end
    scenario "New ticket link is not shown to a user with permission" do
      define_permission(user,'view', project)
      visit project_path(project)
      expect(page).to_not have_link("New Ticket")
    end
    scenario "edit ticket link is shown to a user with permission" do
      define_permission(user,'view', project)
      define_permission(user,'edit ticket', project)
      visit project_path(project)
      click_link ticket.title
      expect(page).to have_link("Edit Ticket")
    end
    scenario "edit ticket link is not shown to a user with permission" do
      define_permission(user,'view', project)
      visit project_path(project)
      click_link ticket.title
      expect(page).to_not have_link("Edit Ticket")
    end
    scenario "delete ticket link is shown to a user with permission" do
      define_permission(user,'view', project)
      define_permission(user,'delete ticket', project)
      visit project_path(project)
      click_link ticket.title
      expect(page).to have_link("Delete Ticket")
    end
    scenario "delete ticket link is not shown to a user with permission" do
      define_permission(user,'view', project)
      visit project_path(project)
      click_link ticket.title
      expect(page).to_not have_link("Delete Ticket")
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
    scenario "new ticket is shown to admin" do
      visit project_path(project)
      expect(page).to have_link("New Ticket")
    end
    scenario "edit ticket is shown to admin" do
      visit project_path(project)
      click_link ticket.title
      expect(page).to have_link("Edit Ticket")
    end
    scenario "delete ticket is shown to admin" do
      visit project_path(project)
      click_link ticket.title
      expect(page).to have_link("Delete Ticket")
    end
  end

end
