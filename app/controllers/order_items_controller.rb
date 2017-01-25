class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_order
    @order_item = @order.create_or_update_order_item(order_item_params)
    @order_item.save if @order_item.persisted?
    session[:order_id] = @order.id if @order.save
  end

  def update
    @order = current_order
    authorize @order, :update?
    @order_item = @order.order_items.find(params[:id])
    if @order_item.update_attributes(order_item_params)
      @order.reload
      flash[:success] = 'Update successfully.'
    else
      flash[:error] = 'Update failed.'
    end
    redirect_to show_cart_path
  end

  def destroy
    @order = current_order
    authorize @order, :update?
    @order_item = @order.order_items.find(params[:id])
    if @order_item.destroy
      @order.save
      flash[:success] = 'Remove successfully.'
    else
      flash[:error] = 'Remove failed.'
    end
    redirect_to show_cart_path
  end

  private

    def order_item_params
      params.require(:order_item).permit(:item_id, :quantity)
    end

end
