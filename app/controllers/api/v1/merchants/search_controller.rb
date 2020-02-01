class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_by(request.query_parameters)
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def index
    merchants = Merchant.where(request.query_parameters)
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end
end
