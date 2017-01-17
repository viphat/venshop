class ItemsController < ApplicationController

  def index
    # Fetch Newest Items
    page = params[:page] || 1
    @items = Item.newest.page(page).per(4)
  end

  def show
    @item = Item.find_by_id(params[:id])
    return render "items/_item_not_found" if @item.nil?
    add_breadcrumb "#{@item.category.category_name}", category_path(@item.category)
    add_breadcrumb "Item ID #{@item.id}", item_path(@item)
  end

end
