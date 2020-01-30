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
end
