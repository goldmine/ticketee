require 'rails_helper'

feature 'viewing tickets' do
  before do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project, name: "TextMate 2")
    FactoryGirl.create(:ticket,
                       user_id: user.id,
                       project: project,
                       title: "Make it shiny",
                       description: "it should more than 10")

    project2 = FactoryGirl.create(:project, name: "Internet Explorer")
    FactoryGirl.create(:ticket,
                       project: project2,
                       user_id: user.id,
                       title: "project2 ticket",
                       description: "it should more than 10")
    visit '/'
  end

  scenario 'view tickets for a given project' do
    visit '/'
    click_link 'TextMate 2'
    expect(page).to have_content("Make it shiny")
    expect(page).to_not have_content("project2 ticket")

    click_link 'Make it shiny'
    within("#ticket h2") do
      expect(page).to have_content("Make it shiny")
    end
    expect(page).to have_content("it should more than 10")
  end
end
