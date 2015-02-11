require 'rails_helper'

feature "creating users" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:user) { FactoryGirl.create(:user) }

  context 'admin user' do
    before do
      sign_in_as(admin)
      visit '/'
      click_link 'Admin'
      click_link 'Users'
      click_link 'New User'
    end

    scenario "create a new user" do
      fill_in "Email", with: "test@admin.com"
      fill_in "Password", with: "password"
      click_button "Create User"
      expect(page).to have_content("User has been created")
    end
  end

end
