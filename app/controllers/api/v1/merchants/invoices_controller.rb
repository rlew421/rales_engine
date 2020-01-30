class Api::V1::Merchants::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    invoices = merchant.invoices
    serialized = InvoiceSerializer.new(invoices)
    render json: serialized
  end
end
