require 'rails_helper'

describe 'transactions API' do
  it "sends a list of transactions" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant)
    transaction_1 = invoice.transactions.create
    transaction_2 = invoice.transactions.create
    transaction_3 = invoice.transactions.create
    transaction_4 = invoice.transactions.create
    transaction_5 = invoice.transactions.create
    transaction_6 = invoice.transactions.create

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].count).to eq(6)
  end

  it "sends one transaction by its id" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = customer.invoices.create(merchant: merchant)
    transaction = invoice.transactions.create
    id = transaction.id

    get "/api/v1/transactions/#{id}"

    expect(response).to be_successful

    transaction = JSON.parse(response.body)

    expect(transaction["data"]["id"]).to eq("#{id}")
  end

  it "can find one transaction by id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer)
    invoice_2 = merchant.invoices.create(customer: customer)

    transaction_1 = invoice_1.transactions.create
    transaction_2 = invoice_2.transactions.create

    get "/api/v1/transactions/find?id=#{transaction_2.id}"

    expect(response).to be_successful

    transaction = JSON.parse(response.body)

    expect(transaction["data"]["attributes"]["id"]).to eq(transaction_2.id)
    expect(transaction["data"]["attributes"]["id"]).to_not eq(transaction_1.id)
  end

  it "can find all transactions by id" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = customer.invoices.create(merchant: merchant)
    invoice_2 = customer.invoices.create(merchant: merchant)
    transaction_1 = invoice_1.transactions.create
    transaction_2 = invoice_2.transactions.create
    id_1 = transaction_1.id
    id_2 = transaction_2.id

    get "/api/v1/transactions/find_all?id=#{id_2}"

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"][0]["id"]).to eq("#{id_2}")
    expect(transactions["data"][0]["id"]).to_not eq("#{id_1}")
  end

  it "sends the invoice associated with one transactions" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer_1.invoices.create(merchant: merchant)
    invoice_2 = customer_2.invoices.create(merchant: merchant)
    transaction = invoice_2.transactions.create
    id = invoice_2.id

    get "/api/v1/transactions/#{transaction.id}/invoice"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["id"]).to eq("#{id}")
  end
end
