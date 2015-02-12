require 'rails_helper'

feature 'Signing up' do
  scenario 'successfully sign up' do
    visit new_user_path
    fill_in '邮箱', with: "test@test.com"
    fill_in '密码', with: "test@test.com"
    fill_in '密码确认', with: "test@test.com"
    click_button '提交'

    expect(page).to have_content('注册成功！')
  end
end
