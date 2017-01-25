class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception, prepend: true
  add_breadcrumb 'Home', :root_path
  helper_method :current_order

  private

    def current_order
      return Order.find(session[:order_id]) if session[:order_id].present?
      order = Order.find_by(user: current_user, status: :in_progress)
      return Order.new(user: current_user) if order.nil?
      session[:order_id] = order.id
      order
    end

end
