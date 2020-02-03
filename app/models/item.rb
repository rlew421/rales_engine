class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.top_items(quantity)
    Item.joins(invoices: [:invoice_items, :transactions])
            .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
            .group(:id)
            .where(transactions: {result: 'success'})
            .order('revenue desc')
            .limit(quantity)
  end
end
