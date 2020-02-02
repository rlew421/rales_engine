class Api::V1::Customers::SearchController < ApplicationController
  def show
    customer = Customer.find_by(request.query_parameters)
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def index
    customers = Customer.where(request.query_parameters)
    serialized = CustomerSerializer.new(customers)
    render json: serialized
  end
end
