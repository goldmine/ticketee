require 'rails_helper'

describe "/api/v1/projects", type: :api do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { user.auth_token }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:project2) { FactoryGirl.create(:project, name: 'Access deny') }

  before do
    define_permission(user, 'view', project)
  end

  context 'project viewable by this user' do

    let(:url) { "/api/v1/projects" }
    it 'json' do
      get "#{url}.json", token: token
      projects_json = Project.for(user).all.to_json
      expect(last_response.status).to eql(200)
      expect(last_response.body).to eql(projects_json)

      projects = JSON.parse(last_response.body)
      result1 = projects.any? do |p|
        p["name"] == project.name
      end
      result2 = projects.any? do |p|
        p["name"] == "Access deny"
      end
      expect(result1).to eql(true)
      expect(result2).to eql(false)
    end

    context 'creating a project' do
      let(:url) { "/api/v1/projects" }
      before do
        user.admin = true
        user.save
      end
      it 'json' do
        post "#{url}.json", token: token,
                            project: { name: "inspector" }
        project = Project.find_by_name("inspector")
        route = "/api/v1/projects/#{project.id}"

        expect(last_response.body).to eql(project.to_json)
        expect(last_response.status).to eql(200)
        expect(last_response.headers["Location"]).to eql(route)
      end

      it 'incorrent json' do
        post "#{url}.json", token: token,
                            project: {name: ""}
        errors = {"name" => ["can't be blank"]}.to_json
        expect(last_response.body).to eql(errors)

      end
    end
  end

  context "show" do
    let!(:url) { "/api/v1/projects/#{project.id}" }

    before do
      FactoryGirl.create(:ticket, project: project, title: "test ticket")
    end

    it "JSON" do
      get "#{url}.json", token: token
      project_json = project.to_json(methods: "last_ticket")

      expect(last_response.body).to eql(project_json)
      expect(last_response.status).to eql(200)

      project_response = JSON.parse(last_response.body)
      ticket_title = project_response["last_ticket"]["title"]

      expect(ticket_title).to eql("test ticket")
    end
  end

  context 'updating a project' do
    before do
      user.admin = true
      user.save
    end

    let!(:url) { "/api/v1/projects/#{project.id}" }
    it 'successful json' do
      put "#{url}.json", token: token,
                         project: { name: "test project" }
      expect(last_response.status).to eql(200)
      project.reload
      expect(last_response.body).to eql(project.to_json)
      expect(project.name).to eql("test project")
    end
    it 'unsuccessful json' do
      put "#{url}.json", token: token,
                         project: { name: "" }
      errors = { "name" => ["can't be blank"] }
      expect(last_response.body).to eql(errors.to_json)
      expect(last_response.status).to eql(422)
    end
  end

  context 'updating a project' do
    before do
      user.admin = true
      user.save
    end
    let!(:url) { "/api/v1/projects/#{project.id}" }

    it 'json' do
      delete "#{url}.json", token: token
      expect(last_response.status).to eql(204)
    end

  end
end
