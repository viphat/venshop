class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update, :destroy]
  before_action -> { authorize(@order, :manage?) }, only: [:show, :update, :destroy]

  layout 'without_sidebar'

  def index
    page = params[:page] || 1
    authorize Order, :manage?
    @orders = Order.newest.includes(order_items: :item).page(page).per(Order::PAGE_SIZE)
  end

  def show; end

  def update
    if @order.update_attributes(order_params)
      flash[:success] = 'The order was updated successfully.'
      @order.reload
    else
      flash[:error] = 'The order was updated failed.'
    end
    render 'show'
  end

  def destroy
    if @order.destroy
      flash[:success] = 'The order was destroyed successfully.'
      return redirect_to admin_orders_path
    end
    flash[:error] = 'The order was destroyed failed.'
    render 'show'
  end

  private

    def order_params
      params.require(:order).permit(:status)
    end

    def set_order
      @order = Order.includes(order_items: :item).find(params[:id])
    end

end
