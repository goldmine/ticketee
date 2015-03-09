require 'rails_helper'

describe "/api/v1/projects", type: :api do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { user.auth_token }
  let!(:project) { FactoryGirl.create(:project) }

  before do
    define_permission(user, 'view', project)
  end

  context 'index' do
    before do
      5.times do
        FactoryGirl.create(:ticket, project: project, user: user)
      end
    end

    let!(:url) { "/api/v1/projects/#{project.id}/tickets" }
    it 'json' do
      get "#{url}.json", token: token

      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(project.tickets.to_json)
    end
  end


end
