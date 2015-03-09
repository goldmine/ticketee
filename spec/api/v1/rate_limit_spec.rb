require 'rails_helper'

describe "rate limiting", type: :api do
  let!(:user) { FactoryGirl.create(:user) }

  it 'counts the user requrest' do

    expect(user.request_count).to eql(0)
    get "/api/v1/projects.json", token: user.auth_token
    user.reload
    expect(user.request_count).to eql(1)
  end

  it 'stop if limit reached' do
    user.update_attributes({"request_count" => 101})
    get "/api/v1/projects.json", token: user.auth_token
    error = {"error" => "Rate limit exceeded"}
    expect(last_response.body).to eql(error.to_json)
  end

end
