require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  context "standard users" do
    before do
      sign_in(user)
    end

    actions = { new: :get,
                edit: :get,
                create: :post,
                update: :put,
                destroy: :delete }

    actions.each do |action, method|
      it "cannot access #{action} action" do
        sign_in(user)
        send(method, action, id: FactoryGirl.create(:project))
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eql("你没有权限执行！")
      end
    end

  end


  it "display error for a missing project" do
    get :show, id: "not-here"
    expect(response).to redirect_to(projects_path)
    message = "Project could not be found"
    expect(flash[:alert]).to eql(message)
  end
end
