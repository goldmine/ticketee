require 'rails_helper'

feature 'Profile page' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit user_path(user)
  end

  scenario 'viewing' do
    expect(page).to have_content(user.email)
  end

  scenario 'Editing user' do
    click_link '更新个人信息'
    fill_in '邮箱', with: 'new@test.com'
    click_button '提交'
    expect(page).to have_content('更新成功！')
  end
end
