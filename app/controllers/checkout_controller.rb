class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def new
    @checkout = initialize_checkout
  end

  def create
    @checkout = initialize_checkout
    unless @checkout.order.checkout_order(checkout_params[:address])
      flash[:error] = "Checkout unsucceeded!"
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
      Checkout.new(
        order: current_order,
        user: current_user,
        address: current_user.address
      )
    end

end
