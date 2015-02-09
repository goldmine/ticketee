require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  context "standard user" do
    before { sign_in(user) }

    it "can not access index" do
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql("你没有权限执行！")
    end
  end

end
