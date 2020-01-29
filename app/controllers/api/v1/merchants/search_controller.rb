class Api::V1::Merchants::SearchController < ApplicationController
  def top_x_merchants
    merchants = Merchant.top_merchants(params[:quantity])
    render json: merchants
  end
end
