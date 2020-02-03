require 'rails_helper'

describe "merchants API" do
  it "sends list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(5)
  end

  it "sends one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq("#{id}")
  end

  it "can find one merchant by id" do
    id_1 = create(:merchant).id
    id_2 = create(:merchant).id

    get "/api/v1/merchants/find?id=#{id_2}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["attributes"]["id"]).to eq(id_2)
    expect(merchant["data"]["attributes"]["id"]).to_not eq(id_1)
  end

  it "can find all merchants by id" do
    id_1 = create(:merchant).id
    id_2 = create(:merchant).id

    get "/api/v1/merchants/find_all?id=#{id_2}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"][0]["id"]).to eq("#{id_2}")
    expect(merchant["data"][0]["id"]).to_not eq("#{id_1}")
  end

  it "can find one merchant by name" do
    merchant_1 = create(:merchant)
    name_1 = merchant_1.name
    merchant_2 = create(:merchant)
    name_2 = merchant_2.name

    get "/api/v1/merchants/find?name=#{name_1}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_1.id)
    expect(merchant["data"]["attributes"]["id"]).to_not eq(merchant_2.id)
  end

  it "can find all merchants by name" do
    merchant_1 = create(:merchant)
    name_1 = merchant_1.name
    merchant_2 = create(:merchant)
    name_2 = merchant_2.name

    get "/api/v1/merchants/find_all?name=#{name_2}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"][0]["id"]).to eq("#{merchant_2.id}")
    expect(merchants["data"][0]["id"]).to_not eq("#{merchant_1.id}")
  end

  it "can find one merchant by created at date" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{merchant_2.created_at}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_2.id)
    expect(merchant["data"]["attributes"]["id"]).to_not eq(merchant_1.id)
  end

  it "can find all merchants by created at date" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find_all?created_at=#{merchant_2.created_at}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"][0]["id"]).to eq("#{merchant_2.id}")
    expect(merchants["data"][0]["id"]).to_not eq("#{merchant_1.id}")
  end

  it "can find one merchant by updated at date" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{merchant_2.updated_at}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_2.id)
    expect(merchant["data"]["attributes"]["id"]).to_not eq(merchant_1.id)
  end

  it "can find all merchants by updated at date" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find_all?updated_at=#{merchant_2.updated_at}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"][0]["id"]).to eq("#{merchant_2.id}")
    expect(merchants["data"][0]["id"]).to_not eq("#{merchant_1.id}")
  end

  it "sends list of all items associated with one merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Water Bottle', description: 'Stay hydrated', unit_price: '20.00')
    item_2 = merchant_1.items.create(name: 'Chocolate bar', description: 'Be careful, it might melt!', unit_price: '2.00')
    item_3 = merchant_2.items.create(name: 'Sunscreen', description: 'Protect yourself from UV rays', unit_price: '7.00')

    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful
    merchant_1_items = JSON.parse(response.body)

    expect(merchant_1_items["data"].length).to eq(2)
    expect(merchant_1_items["data"][0]["attributes"]["id"]).to eq(item_1.id)
    expect(merchant_1_items["data"][0]["attributes"]["name"]).to eq(item_1.name)
    expect(merchant_1_items["data"][1]["attributes"]["id"]).to eq(item_2.id)
    expect(merchant_1_items["data"][1]["attributes"]["name"]).to eq(item_2.name)
    expect(merchant_1_items["data"][2]).to be_nil
  end

  it "sends list of all invoices associated with one merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant_1.invoices.create(customer: customer)
    invoice_2 = merchant_1.invoices.create(customer: customer)
    invoice_3 = merchant_2.invoices.create(customer: customer)

    get "/api/v1/merchants/#{merchant_1.id}/invoices"

    expect(response).to be_successful
    merchant_1_invoices = JSON.parse(response.body)

    expect(merchant_1_invoices["data"].length).to eq(2)
    expect(merchant_1_invoices["data"][0]["attributes"]["id"]).to eq(invoice_1.id)
    expect(merchant_1_invoices["data"][1]["attributes"]["id"]).to eq(invoice_2.id)
    expect(merchant_1_invoices["data"][2]).to be_nil
  end

  it "can find favorite customer of one merchant" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)

    merchant = create(:merchant)

    invoice_1 = merchant.invoices.create(customer: customer_1)
    invoice_2 = merchant.invoices.create(customer: customer_1)
    invoice_3 = merchant.invoices.create(customer: customer_1)
    invoice_4 = merchant.invoices.create(customer: customer_2)

    transaction_1 = invoice_1.transactions.create(result: 'success')
    transaction_2 = invoice_2.transactions.create(result: 'success')
    transaction_3 = invoice_3.transactions.create(result: 'success')
    transaction_4 = invoice_4.transactions.create(result: 'success')

    get "/api/v1/merchants/#{merchant.id}/favorite_customer"

    expect(response).to be_successful

    customer = JSON.parse(response.body)

    expect(customer["data"]["id"]).to eq("#{customer_1.id}")
    expect(customer["data"]["id"]).to_not eq("#{customer_2.id}")
  end

  it "can return the top X merchants ranked by total revenue" do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    item_1 = merchant_1.items.create(name: 'Water Bottle', description: 'Stay hydrated', unit_price: '20.00')
    item_2 = merchant_2.items.create(name: 'Chocolate bar', description: 'Be careful, it might melt!', unit_price: '2.00')
    item_3 = merchant_3.items.create(name: 'Sunscreen', description: 'Protect yourself from UV rays', unit_price: '7.00')

    invoice_1 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 5, unit_price: '20.00')

    invoice_2 = customer.invoices.create(merchant: merchant_2, status: 'shipped')
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 7, unit_price: '2.00')

    invoice_3 = customer.invoices.create(merchant: merchant_3, status: 'shipped')
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 10, unit_price: '7.00')

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4140149827486249', result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4140149827486249', result: 'success')
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4140149827486249', result: 'success')

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    top_x_merchants = JSON.parse(response.body)

    expect(top_x_merchants["data"][0]["id"]).to eq("#{merchant_1.id}")
    expect(top_x_merchants["data"][1]["id"]).to eq("#{merchant_3.id}")
    expect(top_x_merchants["data"][2]).to be_nil
  end
end
