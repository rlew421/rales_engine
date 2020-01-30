class Api::V1::Invoices::ItemsController < ApplicationController
  def index
    invoice = Invoice.find(params[:id])
    items = invoice.items
    serialized = ItemSerializer.new(items)
    render json: serialized
  end
end
