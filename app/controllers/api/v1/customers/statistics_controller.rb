class Api::V1::Customers::StatisticsController < ApplicationController
  def favorite_merchant
    customer = Customer.find(params[:id])
    merchant = customer.favorite_merchant
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end
end
