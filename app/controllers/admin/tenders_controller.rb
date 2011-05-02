class Admin::TendersController < ApplicationController
  before_filter :load_data
  def accept
    if @tender.approve!
      flash[:notice] = "Комментарий одобрен"
      redirect_to admin_order_path(@order)
    else
      redirect_to admin_orders_path
    end
  end

  def deny
    if @tender.rejected!
      flash[:notice] = "Комментарий заблокирован"
      redirect_to admin_order_path(@order)
    else
      redirect_to admin_orders_path
    end

  end

  private

  def load_data
    if @order = Order.find(params[:order_id])
      @tender = @order.tenders.find(params[:id])
    end
    if @order.blank? || @tender.blank?
      flash[:error] = "Ошибочный запрос"
      redirect_to root_path
    end
  end

end
