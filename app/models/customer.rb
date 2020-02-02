class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    merchants.joins(invoices: :transactions)
            .select("merchants.*, count(transactions.id) as total_transactions")
            .where("transactions.result = 'success'")
            .group(:id)
            .order('total_transactions DESC')
            .limit(1)
            .first
  end
end
