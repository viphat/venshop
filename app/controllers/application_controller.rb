class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception, prepend: true
  add_breadcrumb 'Home', :root_path
  helper_method :current_order

  private

  def set_page_params
    @page = params[:page] || 1
  end

  def current_order
    if session[:order_id].present?
      order = OrderService.get_current_order_by_order_id(session[:order_id])
      return order unless order.nil?
      session.delete(:order_id)
    end
    order = OrderService.get_current_order(current_user)
    session[:order_id] = order.id
    order
  end
end
