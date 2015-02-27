require 'rails_helper'

feature 'managing states' do
  before do
    load Rails.root + "db/seeds.rb"
    sign_in_as(FactoryGirl.create(:admin_user))
  end

  scenario 'making a state as default' do
    visit '/'
    click_link 'Admin'
    click_link 'States'

    within('#states .New') do
      click_link 'Make Default'
    end

    expect(page).to have_content("New is now the default state")

  end
end
