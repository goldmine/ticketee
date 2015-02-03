require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  it "display error for a missing project" do
    get :show, id: "not-here"
    expect(response).to redirect_to(projects_path)
    message = "Project could not be found"
    expect(flash[:alert]).to eql(message)
  end
end
