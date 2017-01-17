class ItemsController < ApplicationController

  def index
    # Fetch Newest Items
    page = params[:page] || 1
    @items = Item.newest.page(page).per(4)
  end

  def show
    @item = Item.find_by_id(params[:id])
  end


end
