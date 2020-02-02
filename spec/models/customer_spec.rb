require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:merchants).through(:invoices)}
  end

  describe "instance methods" do
    xit "favorite_merchant" do
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

      expect(customer.favorite_merchant).to eq(merchant_2)
    end
  end
end
