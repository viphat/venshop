class OrderService
  def self.get_current_order_by_order_id(order_id)
    Order.find_by_id(order_id)
  end

  def self.get_current_order(current_user)
    order = Order.find_by(user: current_user, status: :in_progress)
    return Order.new(user: current_user) if order.nil?
    order
  end
end
