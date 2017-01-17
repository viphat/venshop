class ItemsController < ApplicationController

  def index
    # Fetch Newest Items
    page = params[:page] || 1
    @items = Item.newest.page(page).per(10)
  end


end
