class OrderMailerPreview < ActionMailer::Preview

  def new_order
    order = Order.first
    OrderMailer.new_order(order)
  end

end
