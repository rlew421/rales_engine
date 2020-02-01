class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.find_by(request.query_parameters)
    serialized = ItemSerializer.new(item)
    render json: serialized
  end
end
