require 'rails_helper'

describe "api errors", type: :api do
  it 'making a request without token' do
    get "api/v1/projects.json", token: ""
    error = { error: "token is invalid" }
    expect(last_response.body).to eql(error.to_json)
  end
end
