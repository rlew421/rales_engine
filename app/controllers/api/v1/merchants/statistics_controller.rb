class Api::V1::Merchants::StatisticsController < ApplicationController
  def favorite_customer
    merchant = Merchant.find(params[:id])
    customer = merchant.favorite_customer
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end
end
