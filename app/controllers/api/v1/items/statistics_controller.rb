class Api::V1::Items::StatisticsController < ApplicationController
  def top_items_by_revenue
    items = Item.top_items(params[:quantity].to_i)
    serialized = ItemSerializer.new(items)
    render json: serialized
  end
end
