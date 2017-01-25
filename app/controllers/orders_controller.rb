class OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'without_sidebar'

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
