class Api::V1::Items::MerchantController < ApplicationController
  def show
    item = Item.find(params[:id])
    merchant = item.merchant
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end
end
