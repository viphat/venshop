class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_params, only: [:index]
  layout 'without_sidebar'

  def index
    @orders = Order.newest.without_status(:in_progress).where(user: current_user)
                   .includes(order_items: :item)
                   .page(@page).per(Order::PAGE_SIZE)
    @orders.each { |x| authorize x, :show? }
  end

  def destroy
    @order = Order.find_by(params[:id])
    authorize @order, :update?
    if @order.update_attributes(status: :cancel)
      flash[:success] = 'Your order have been canceled'
      session.delete(:order_id)
      return redirect_to root_path
    end
    flash[:error] = 'Your order can\'t be canceled'
    redirect_to new_checkout_path
  end

end
