class Api::V1::Customers::SearchController < ApplicationController
  def show
    customer = Customer.find_by(request.query_parameters)
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end
end
