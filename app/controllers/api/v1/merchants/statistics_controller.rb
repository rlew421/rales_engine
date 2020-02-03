class Api::V1::Merchants::StatisticsController < ApplicationController
  def favorite_customer
    merchant = Merchant.find(params[:id])
    customer = merchant.favorite_customer
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def top_merchants_by_revenue
    merchants = Merchant.top_merchants(params[:quantity].to_i)
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end
end
