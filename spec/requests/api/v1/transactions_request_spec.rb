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
