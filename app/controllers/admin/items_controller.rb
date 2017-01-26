class Admin::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_params, only: [:index]
  before_action :get_item, only: [:update]
  before_action -> { authorize(Item, :update?)}, only: [:index, :update]

  layout 'without_sidebar'

  def index
    @items = Item.newest.page(@page).per(Item::ITEMS_ON_ADMIN_PAGE)
  end

  def update
    if !item_params[:import_quantity].blank? && item_params[:import_quantity].to_i > 0
      if @item.import_item(item_params[:import_quantity].to_i)
        flash[:success] = "Import Item #{@item.item_name} successfully."
        return redirect_back(fallback_location: admin_items_path)
      end
    end
    flash[:error] = "Import Item #{@item.item_name} failed."
    redirect_back(fallback_location: admin_items_path)
  end

  private

    def get_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:import_quantity)
    end

end
