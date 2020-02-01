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

  it "can find one invoice by id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer)
    invoice_2 = merchant.invoices.create(customer: customer)

    get "/api/v1/invoices/find?id=#{invoice_2.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_2.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_1.id)
  end

  it "can find one invoice by customer id" do
    merchant = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer_1)
    invoice_2 = merchant.invoices.create(customer: customer_2)

    get "/api/v1/invoices/find?customer_id=#{customer_2.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_2.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_1.id)
  end

  it "can find one invoice by merchant id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    customer = create(:customer)
    invoice_1 = customer.invoices.create(merchant: merchant_1)
    invoice_2 = customer.invoices.create(merchant: merchant_2)

    get "/api/v1/invoices/find?merchant_id=#{merchant_2.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_2.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_1.id)
  end

  it "can find first instance of invoice by status" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')

    get "/api/v1/invoices/find?status=#{invoice_2.status}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_1.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_2.id)
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

  it "sends the items associated with one invoice" do
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

    get "/api/v1/invoices/#{invoice_1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].length).to eq(3)
    expect(items["data"][0]["attributes"]["id"]).to eq(item_1.id)
    expect(items["data"][1]["attributes"]["id"]).to eq(item_2.id)
    expect(items["data"][2]["attributes"]["id"]).to eq(item_3.id)
    expect(items["data"][3]).to be_nil
  end

  it "sends the transactions associated with one invoice" do
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

    transaction_1 = invoice_1.transactions.create
    transaction_2 = invoice_1.transactions.create
    transaction_3 = invoice_2.transactions.create

    get "/api/v1/invoices/#{invoice_1.id}/transactions"

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].length).to eq(2)
    expect(transactions["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    expect(transactions["data"][1]["attributes"]["id"]).to eq(transaction_2.id)
    expect(transactions["data"][2]).to be_nil
  end
end
