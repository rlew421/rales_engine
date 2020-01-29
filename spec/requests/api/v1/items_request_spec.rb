require 'rails_helper'

describe "items API" do
  it "sends list of items" do
    merchant = create(:merchant)
    item_1 = merchant.items.create
    item_2 = merchant.items.create
    item_3 = merchant.items.create

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(3)
  end

  it "sends one item by its id" do
    merchant = create(:merchant)
    item = merchant.items.create
    id = item.id

    get "/api/v1/items/#{item.id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq("#{id}")
  end
end
