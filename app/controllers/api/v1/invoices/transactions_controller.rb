class Api::V1::Invoices::TransactionsController < ApplicationController
  def index
    invoice = Invoice.find(params[:id])
    transactions = invoice.transactions
    serialized = TransactionSerializer.new(transactions)
    render json: serialized
  end
end
