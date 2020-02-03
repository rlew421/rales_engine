require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  it "top items" do
    customer = create(:customer)
    merchant = create(:merchant)

    item_1 = merchant.items.create(name: 'Water Bottle', description: 'Stay hydrated', unit_price: '20.00')
    item_2 = merchant.items.create(name: 'Chocolate bar', description: 'Be careful, it might melt!', unit_price: '2.00')
    item_3 = merchant.items.create(name: 'Sunscreen', description: 'Protect yourself from UV rays', unit_price: '7.00')

    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 5, unit_price: '20.00')

    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 7, unit_price: '2.00')

    invoice_3 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 10, unit_price: '7.00')

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4140149827486249', result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4140149827486249', result: 'success')
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4140149827486249', result: 'success')

    expect(Item.top_items(2)).to eq([item_1, item_3])
  end
end
