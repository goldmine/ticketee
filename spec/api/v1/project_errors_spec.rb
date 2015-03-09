require 'rails_helper'

describe "project api errors", type: :api do
  context 'standard user' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'cannot create project' do
      url = "/api/v1/projects"
      post "#{url}.json", token: user.auth_token,
                          project: { name: "inspector" }

      error = { "error" => "You must be an admin to do that" }

      expect(last_response.body).to eql(error.to_json)
      expect(last_response.status).to eql(401)
      expect(Project.find_by_name("inspector")).to eql(nil)
    end

    it 'cannot view project they do not have access to' do
      project = FactoryGirl.create(:project)
      url = "/api/v1/projects/#{project.id}"
      get "#{url}.json", token: user.auth_token

      error = { "error" => "The project could not be found" }
      expect(last_response.body).to eql(error.to_json)
      expect(last_response.status).to eql(404)

    end

    it 'can view project they  have access to' do
      project = FactoryGirl.create(:project, name: "test project")
      define_permission(user, 'view', project)
      url = "/api/v1/projects/#{project.id}"
      get "#{url}.json", token: user.auth_token

      @project = JSON.parse(last_response.body)

      expect(last_response.status).to eql(200)
      expect(@project["name"]).to eql("test project")

    end
  end
end
