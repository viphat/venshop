class OrderMailer < ApplicationMailer
  default from: "noreply@zigexn.vn"

  def new_order(order)
    @order = order
    @user = order.user
    mail to: @user.email, subject: "[VENSHOP] - Order #{@order.id} - Confirmation"
  end
end
