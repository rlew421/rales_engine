require 'rails_helper'

describe "invoice items API" do
  it "sends list of invoice_items" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
    item_1 = merchant.items.create
    item_2 = merchant.items.create
    item_3 = merchant.items.create
    invoice_item_1 = invoice.invoice_items.create(item: item_1)
    invoice_item_2 = invoice.invoice_items.create(item: item_2)
    invoice_item_3 = invoice.invoice_items.create(item: item_3)
    invoice_item_4 = invoice.invoice_items.create(item: item_3)
    invoice_item_5 = invoice.invoice_items.create(item: item_3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].count).to eq(5)
  end

  it "sends one invoice by its id" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
    item = merchant.items.create
    invoice_item = invoice.invoice_items.create(item: item)
    id = invoice_item.id

    get "/api/v1/invoice_items/#{invoice_item.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq("#{id}")
  end
end
