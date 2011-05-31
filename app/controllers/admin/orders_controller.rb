class Admin::OrdersController < ApplicationController
  filter_access_to :all, :attribute_check => false

  def index
    @orders = Order.includes(:tenders).order("orders.state, orders.updated_at DESC").
      paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @order = Order.find(params[:id])
  end

  def accept
    if (@order = Order.find(params[:id])) && @order.to_active!
      flash[:notice] = "Заказ одобрен"
      redirect_to admin_order_path(@order)
    else
      redirect_to admin_orders_path
    end
  end

  def deny
    if (@order = Order.find(params[:id])) && @order.to_cancel!
      flash[:notice] = "Заказ заблокирован"
      redirect_to admin_order_path(@order)
    else
      redirect_to admin_orders_path
    end

  end
end
