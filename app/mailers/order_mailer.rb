class OrderMailer < ApplicationMailer
  default from: "phatdv@zigexn.vn"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.new_order.subject
  #
  def new_order(order)
    @order = order
    @user = order.user
    mail to: @user.email, subject: "[VENSHOP] - Order #{@order.id} - Confirmation"
  end
end
