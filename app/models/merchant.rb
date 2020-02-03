class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def favorite_customer
    customers.joins(invoices: :transactions)
            .select("customers.*, count(transactions.id) as total_transactions")
            .where("transactions.result = 'success'")
            .group(:id)
            .order('total_transactions DESC')
            .limit(1)
            .first
  end

  def self.top_merchants(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
            .group(:id)
            .where(transactions: {result: 'success'})
            .order('revenue desc')
            .limit(quantity)
  end
end
