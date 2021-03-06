class Api::V1::Invoices::SearchController < ApplicationController
  def show
    invoice = Invoice.find_by(request.query_parameters)
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end

  def index
    invoices = Invoice.where(request.query_parameters)
    serialized = InvoiceSerializer.new(invoices)
    render json: serialized
  end
end
