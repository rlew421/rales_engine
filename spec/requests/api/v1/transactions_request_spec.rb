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

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq("#{id}")
  end
end
