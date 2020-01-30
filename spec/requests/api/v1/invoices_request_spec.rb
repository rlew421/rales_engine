require 'rails_helper'

describe "invoices API" do
  it "sends list of invoices" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_3 = customer.invoices.create(merchant: merchant, status: 'shipped')

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(3)
  end

  it "sends one invoice by its id" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
    id = invoice.id

    get "/api/v1/invoices/#{invoice.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq("#{id}")
  end

  it "sends the customer associated with one invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
    id = customer.id

    get "/api/v1/invoices/#{invoice.id}/customer"

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer["data"]["id"]).to eq("#{id}")
  end

  it "sends the merchant associated with one invoice" do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    invoice = merchant_1.invoices.create(customer: customer, status: 'shipped')
    id = merchant_1.id

    get "/api/v1/invoices/#{invoice.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["id"]).to eq("#{id}")
  end

  it "sends the invoice items associated with one invoice" do
    customer = create(:customer)
    merchant = create(:merchant)

    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')

    item_1 = merchant.items.create
    item_2 = merchant.items.create
    item_3 = merchant.items.create

    invoice_item_1 = invoice_1.invoice_items.create(item: item_1)
    invoice_item_2 = invoice_1.invoice_items.create(item: item_2)
    invoice_item_3 = invoice_1.invoice_items.create(item: item_3)
    invoice_item_4 = invoice_2.invoice_items.create(item: item_3)

    get "/api/v1/invoices/#{invoice_1.id}/invoice_items"

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].length).to eq(3)
    expect(invoice_items["data"][0]["attributes"]["id"]).to eq(invoice_item_1.id)
    expect(invoice_items["data"][1]["attributes"]["id"]).to eq(invoice_item_2.id)
    expect(invoice_items["data"][2]["attributes"]["id"]).to eq(invoice_item_3.id)
    expect(invoice_items["data"][3]).to be_nil
  end
end
