
module AuthenticationHelpers
  def sign_in_as(user)
    visit new_session_path
    fill_in '邮箱', with: user.email
    fill_in '密码', with: user.password
    click_button '提交'
    expect(page).to have_content('登录成功！')
  end
end


