class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :invoice_id, :item_id, :quantity, :unit_price

  attribute :unit_price do |invoice_item|
    invoice_item.unit_price.to_s
  end
end
