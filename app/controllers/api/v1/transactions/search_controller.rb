class Api::V1::Transactions::SearchController < ApplicationController
  def show
    transaction = Transaction.find_by(request.query_parameters)
    serialized = TransactionSerializer.new(transaction)
    render json: serialized
  end
end
