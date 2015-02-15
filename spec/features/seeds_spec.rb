require 'rails_helper'

feature 'seed data' do
  scenario 'the basic' do
    load Rails.root + "db/seeds.rb"
    user = User.where(email: "admin@example.com").first!
    project = Project.where(name: "Ticketee Beta").first!
  end
end
