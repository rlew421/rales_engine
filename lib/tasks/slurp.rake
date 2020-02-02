require 'csv'

def convert_price(unit_price)
  unit_price.to_f/100
end

namespace :slurp do
  desc "TODO"
    task customers: :environment do
      csv_text = File.read(Rails.root.join("db", "data", "customers.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        i = Customer.new
        i.first_name = row["first_name"]
        i.last_name = row["last_name"]
        i.created_at = row["created_at"]
        i.updated_at = row["updated_at"]
        i.save
      end
    end

    task merchants: :environment do
      csv_text = File.read(Rails.root.join("db", "data", "merchants.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        i = Merchant.new
        i.name = row["name"]
        i.created_at = row["created_at"]
        i.updated_at = row["updated_at"]
        i.save
      end
    end

    task items: :environment do
      csv_text = File.read(Rails.root.join("db", "data", "items.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        i = Item.new
        i.name = row["name"]
        i.description = row["description"]
        i.unit_price = convert_price(row["unit_price"])
        i.created_at = row["created_at"]
        i.updated_at = row["updated_at"]
        i.merchant_id = row["merchant_id"]
        i.save
      end
    end

    task invoices: :environment do
      csv_text = File.read(Rails.root.join("db", "data", "invoices.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        i = Invoice.new
        i.status = row["status"]
        i.created_at = row["created_at"]
        i.updated_at = row["updated_at"]
        i.merchant_id = row["merchant_id"]
        i.customer_id = row["customer_id"]
        i.save
      end
    end

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

    task transactions: :environment do
      csv_text = File.read(Rails.root.join("db", "data", "transactions.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        i = Transaction.new
        i.invoice_id = row["invoice_id"]
        i.credit_card_number = row["credit_card_number"]
        i.credit_card_expiration_date = row["credit_card_expiration_date"]
        i.result = row["result"]
        i.created_at = row["created_at"]
        i.updated_at = row["updated_at"]
        i.save
      end
    end
  end
end
