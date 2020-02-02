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
end
