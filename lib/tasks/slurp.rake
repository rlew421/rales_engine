require 'csv'

def convert_price(unit_price)
  unit_price.to_f/100
end

namespace :slurp do
  desc "TODO"
  task invoice_items: :environment do
    csv_text = File.read(Rails.root.join("db", "data", "invoice_items.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      i = InvoiceItem.new
      i.quantity = row["quantity"]
      i.unit_price = convert_price(row["unit_price"])
      i.created_at = row["created_at"]
      i.updated_at = row["updated_at"]
      i.item_id = row["item_id"]
      i.invoice_id = row["invoice_id"]
      i.save
    end
  end

end
