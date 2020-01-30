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
end
