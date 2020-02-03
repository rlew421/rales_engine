require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many(:customers).through(:invoices)}
  end

  describe "instance methods" do
    it "favorite_customer" do
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

      expect(merchant.favorite_customer).to eq(customer_1)
    end

    it "top merchants" do
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

      expect(Merchant.top_merchants(2)).to eq([merchant_1, merchant_3])
    end
  end
end
