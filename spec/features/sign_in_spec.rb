require 'rails_helper'

feature 'Sign in' do
  scenario 'successfully sign in' do
    user = FactoryGirl.create(:user)
    visit '/'
    click_link '登录'
    fill_in '邮箱', with: user.email 
    fill_in '密码', with: user.password
    click_button '提交'

    expect(page).to have_content('登录成功！')
  end

  scenario 'unsuccessfully sign in with wrong information' do
    user = FactoryGirl.create(:user)
    visit '/'
    click_link '登录'
    fill_in '邮箱', with: 'test'
    fill_in '密码', with: user.password
    click_button '提交'

    expect(page).to have_content('登录信息有误！')
  end
end
