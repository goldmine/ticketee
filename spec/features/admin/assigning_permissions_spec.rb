require 'rails_helper'

feature "Assigning permissions" do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }

  before do
    sign_in_as(admin)
    click_link 'Admin'
    click_link 'Users'
    click_link user
    click_link "Permissions"
  end

  scenario "view a project" do
    check_permission_box "view", project
    click_button "Update"
    click_link "退出"

    sign_in_as(user)
    expect(page).to have_content(project.name)
  end

  scenario "creating tickets for a project" do
    check_permission_box "view", project
    check_permission_box "create_tickets", project
    click_button "Update"
    click_link "退出"

    sign_in_as(user)
    click_link project.name
    click_link "New Ticket"
    fill_in "Title", with: "Make it so!"
    fill_in "Description", with: "Shiny shiny shiny shiny!"
    click_button "Create"

    expect(page).to have_content("Ticket was successfully created")

  end

  scenario "update tickets for a project" do
    check_permission_box "view", project
    check_permission_box "create_tickets", project
    check_permission_box "edit_ticket", project
    click_button "Update"
    click_link "退出"

    sign_in_as(user)
    click_link project.name
    click_link ticket.title
    click_link 'Edit Ticket'
    fill_in "Title", with: "edit Make it so!"
    fill_in "Description", with: "Shiny shiny shiny shiny!"
    click_button "Update Ticket"

    expect(page).to have_content("Ticket was successfully updated")

  end

  scenario "delete tickets for a project" do
    check_permission_box "view", project
    check_permission_box "create_tickets", project
    check_permission_box "delete_ticket", project
    click_button "Update"
    click_link "退出"

    sign_in_as(user)
    click_link project.name
    click_link ticket.title
    click_link 'Delete Ticket'

    expect(page).to have_content("Ticket has been destroyed")

  end



end
