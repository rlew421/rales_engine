class Api::V1::Customers::InvoicesController < ApplicationController
  def index
    customer = Customer.find(params[:id])
    invoices = customer.invoices
    serialized = InvoiceSerializer.new(invoices)
    render json: serialized
  end
end
