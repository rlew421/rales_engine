class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.top_merchants(search_amount)
  end
end
