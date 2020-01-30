class Api::V1::Invoices::MerchantController < ApplicationController
  def show
    invoice = Invoice.find(params[:id])
    merchant = invoice.merchant
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end
end
