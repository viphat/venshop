class CheckoutController < ApplicationController
  include CommonHelper
  before_action :authenticate_user!
  layout 'without_sidebar'

  def new
    @checkout = initialize_checkout
    flash.now[:event] = google_analytics_event_tracking('Checkout', 'Clicked')
  end

  def create
    @checkout = initialize_checkout
    unless !checkout_params[:address].blank? &&
           @checkout.order.checkout_order(checkout_params[:address])
      flash[:error] = 'Checkout failed!'
      return redirect_to new_checkout_path
    end
    @checkout.user.update_address(checkout_params[:address])
    session.delete(:order_id) # Clear the Cart
  end

  private

  def checkout_params
    params.require(:checkout).permit(:address)
  end

  def initialize_checkout
    Checkout.new(order: current_order,
                 user: current_user,
                 address: current_user.address)
  end
end
