require 'rails_helper'

describe 'customers API' do
  it "sends a list of customers" do
    create_list(:customer, 7)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(7)
  end

  it "sends one customer by id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq("#{id}")
  end

  it "can find one customer by id" do
    id_1 = create(:customer).id
    id_2 = create(:customer).id

    get "/api/v1/customers/find?id=#{id_2}"

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer["data"]["attributes"]["id"]).to eq(id_2)
    expect(customer["data"]["attributes"]["id"]).to_not eq(id_1)
  end

  it "can find all customers by id" do
    id_1 = create(:customer).id
    id_2 = create(:customer).id

    get "/api/v1/customers/find_all?id=#{id_2}"

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer["data"][0]["id"]).to eq("#{id_2}")
    expect(customer["data"][0]["id"]).to_not eq("#{id_1}")
  end

  it "sends list of all invoices associated with one customer" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer_1.invoices.create(merchant: merchant)
    invoice_2 = customer_1.invoices.create(merchant: merchant)
    invoice_3 = customer_2.invoices.create(merchant: merchant)

    get "/api/v1/customers/#{customer_1.id}/invoices"

    expect(response).to be_successful
    customer_1_invoices = JSON.parse(response.body)

    expect(customer_1_invoices["data"].length).to eq(2)
    expect(customer_1_invoices["data"][0]["attributes"]["id"]).to eq(invoice_1.id)
    expect(customer_1_invoices["data"][1]["attributes"]["id"]).to eq(invoice_2.id)
    expect(customer_1_invoices["data"][2]).to be_nil
  end

  it "sends list of all transactions associated with one customer" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer_1.invoices.create(merchant: merchant)
    invoice_2 = customer_1.invoices.create(merchant: merchant)
    invoice_3 = customer_2.invoices.create(merchant: merchant)
    transaction_1 = invoice_1.transactions.create
    transaction_2 = invoice_2.transactions.create
    transaction_3 = invoice_3.transactions.create

    get "/api/v1/customers/#{customer_1.id}/transactions"

    expect(response).to be_successful

    customer_1_transactions = JSON.parse(response.body)

    expect(customer_1_transactions["data"].length).to eq(2)
    expect(customer_1_transactions["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    expect(customer_1_transactions["data"][1]["attributes"]["id"]).to eq(transaction_2.id)
    expect(customer_1_transactions["data"][2]).to be_nil
  end

  xit "can find the favorite merchant for a customer" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    customer = create(:customer)

    invoice_1 = merchant_1.invoices.create(customer: customer)
    invoice_2 = merchant_2.invoices.create(customer: customer)
    invoice_3 = merchant_2.invoices.create(customer: customer)
    invoice_4 = merchant_2.invoices.create(customer: customer)
    invoice_5 = merchant_3.invoices.create(customer: customer)

    transaction_1 = invoice_1.transactions.create
    transaction_2 = invoice_2.transactions.create
    transaction_3 = invoice_3.transactions.create
    transaction_4 = invoice_4.transactions.create
    transaction_5 = invoice_5.transactions.create

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["id"]).to eq("#{merchant_2.id}")
    expect(merchant["data"]["id"]).to_not eq("#{merchant_1.id}")
    expect(merchant["data"]["id"]).to_not eq("#{merchant_3.id}")
  end
end
