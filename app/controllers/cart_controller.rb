class CartController < ApplicationController
  before_action :authenticate_user!
  layout 'without_sidebar'

  def show
    @order_items = current_order.order_items
  end

end
