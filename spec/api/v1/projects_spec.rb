require 'rails_helper'

describe "/api/v1/projects", type: :api do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }

  before do
    define_permission(user, 'view', project)
  end

  context 'project viewable by this user' do
    let(:url) { "/api/v1/projects" }
    it 'json' do
      get "#{url}.json"
      projects_json = Project.all.to_json
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(projects_json)

      projects = JSON.parse(last_response.body)
      result = projects.any? do |p|
        p["name"] == project.name
      end
      expect(result).to eql(true)




    end

  end
end
