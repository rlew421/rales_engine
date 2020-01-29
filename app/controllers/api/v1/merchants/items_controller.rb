class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    items = merchant.items
    serialized = ItemSerializer.new(items)
    render json: serialized
  end
end
