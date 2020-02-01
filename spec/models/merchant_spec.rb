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
  end
end
