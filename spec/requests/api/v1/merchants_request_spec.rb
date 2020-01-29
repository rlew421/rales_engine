require 'rails_helper'

describe "merchants API" do
  it "sends list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
  end

  it "sends one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq("#{id}")
  end

  it "sends list of all items associated with one merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Water Bottle', description: 'Stay hydrated', unit_price: '20.00')
    item_2 = merchant_1.items.create(name: 'Chocolate bar', description: 'Be careful, it might melt!', unit_price: '2.00')
    item_3 = merchant_2.items.create(name: 'Sunscreen', description: 'Protect yourself from UV rays', unit_price: '7.00')

    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful
    merchant_1_items = JSON.parse(response.body)

    expect(merchant_1_items["data"].length).to eq(2)
    expect(merchant_1_items["data"][0]["attributes"]["id"]).to eq(item_1.id)
    expect(merchant_1_items["data"][0]["attributes"]["name"]).to eq(item_1.name)
    expect(merchant_1_items["data"][1]["attributes"]["id"]).to eq(item_2.id)
    expect(merchant_1_items["data"][1]["attributes"]["name"]).to eq(item_2.name)
    expect(merchant_1_items["data"][2]).to be_nil
  end
end
