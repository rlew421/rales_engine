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

  it "can find one item by id" do
    merchant = create(:merchant)
    item_1 = merchant.items.create
    item_2 = merchant.items.create
    id_1 = item_1.id
    id_2 = item_2.id

    get "/api/v1/items/find?id=#{id_2}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"]["attributes"]["id"]).to eq(id_2)
    expect(item["data"]["attributes"]["id"]).to_not eq(id_1)
  end

  it "can find all items by id" do
    merchant = create(:merchant)
    item_1 = merchant.items.create
    item_2 = merchant.items.create
    id_1 = item_1.id
    id_2 = item_2.id

    get "/api/v1/items/find_all?id=#{id_2}"

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"][0]["id"]).to eq("#{id_2}")
    expect(items["data"][0]["id"]).to_not eq("#{id_1}")
  end

  it "can find one item by name" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    id_1 = item_1.id
    id_2 = item_2.id
    name_1 = item_1.name
    name_2 = item_2.name

    get "/api/v1/items/find?name=#{name_2}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"]["attributes"]["id"]).to eq(id_2)
    expect(item["data"]["attributes"]["id"]).to_not eq(id_1)
  end

  it "can find one item by description" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    id_1 = item_1.id
    id_2 = item_2.id

    get "/api/v1/items/find?description=#{item_2.description}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"]["attributes"]["id"]).to eq(item_2.id)
    expect(item["data"]["attributes"]["id"]).to_not eq(item_1.id)
  end

  it "can find one item by unit_price" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant: merchant, unit_price: 7.50)
    item_2 = create(:item, merchant: merchant, unit_price: 8.50)
    id_1 = item_1.id
    id_2 = item_2.id
    price_1 = item_1.unit_price
    price_2 = item_2.unit_price

    get "/api/v1/items/find?unit_price=#{price_2}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"]["attributes"]["id"]).to eq(id_2)
    expect(item["data"]["attributes"]["id"]).to_not eq(id_1)
  end

  it "can find one item by created at" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)

    get "/api/v1/items/find?created_at=#{item_2.created_at}"

    expect(response).to be_successful

    item = JSON.parse(response.body)
    expect(item["data"]["attributes"]["id"]).to eq(item_2.id)
    expect(item["data"]["attributes"]["id"]).to_not eq(item_1.id)
  end

  it "can find one item by updated at" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)

    get "/api/v1/items/find?updated_at=#{item_2.updated_at}"

    expect(response).to be_successful

    item = JSON.parse(response.body)
    expect(item["data"]["attributes"]["id"]).to eq(item_2.id)
    expect(item["data"]["attributes"]["id"]).to_not eq(item_1.id)
  end

  it "sends a collection of invoice items associated with one item" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant)
    item_1 = merchant.items.create
    item_2 = merchant.items.create
    invoice_item_1 = item_1.invoice_items.create(invoice: invoice)
    invoice_item_2 = item_1.invoice_items.create(invoice: invoice)
    invoice_item_3 = item_2.invoice_items.create(invoice: invoice)

    get "/api/v1/items/#{item_1.id}/invoice_items"

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].length).to eq(2)
    expect(invoice_items["data"][0]["attributes"]["id"]).to eq(invoice_item_1.id)
    expect(invoice_items["data"][1]["attributes"]["id"]).to eq(invoice_item_2.id)
    expect(invoice_items["data"][2]).to be_nil
  end

  it "can send the merchant associated with one item" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item = merchant_1.items.create

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["id"]).to eq("#{merchant_1.id}")
  end
end
