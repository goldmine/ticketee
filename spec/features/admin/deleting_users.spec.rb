require 'rails_helper'

feature 'Deleting users' do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_as(admin)
    visit '/'
    click_link 'Admin'
    click_link 'Users'
  end

  scenario 'deleting a user' do
    click_link user.email
    click_link 'Delete User'

    expect(page).to have_content('User has been deleted')

  end

  scenario 'cannot delete yourself' do
    click_link admin.email
    click_link 'Delete User'

    expect(page).to have_content('You cannot delete yourself!')

  end


end
