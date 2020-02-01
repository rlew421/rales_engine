class Api::V1::InvoiceItems::SearchController < ApplicationController
  def show
    invoice_item = InvoiceItem.find_by(request.query_parameters)
    serialized = InvoiceItemSerializer.new(invoice_item)
    render json: serialized
  end
end
