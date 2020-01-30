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
  end
end
