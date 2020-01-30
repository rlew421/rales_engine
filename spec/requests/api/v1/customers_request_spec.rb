require 'rails_helper'

describe 'customers API' do
  it "sends a list of customers" do
    create_list(:customer, 7)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(7)
  end

  it "sends one customer by id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq("#{id}")
  end
end
