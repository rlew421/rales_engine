require 'rails_helper'

describe "merchants API" do
  it "sends list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
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
  end
end
