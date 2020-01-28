require 'rails_helper'

describe "merchants record endpoints" do
  it "sends list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
  end
end
