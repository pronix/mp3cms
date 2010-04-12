class TendersController < ApplicationController

  before_filter :find_order
  filter_access_to [:new, :create]

  def new
    @tender = current_user.tenders.build
  end

  def create
    @tender = current_user.tenders.new(params[:tender])
    @tender.order_id = @order.id
    if @tender.save
      CheckTender.create!(:user_id => @order.user.id, :tender_id => @tender.id)
      flash[:notice] = 'Комментарий принят.'
      # Отправляем владельцу заказа сообщение что поступила заявка
      Notifier.deliver_new_tender_message(@order, @order.user.email)
      redirect_to notfoundorders_orders_path
    else
      flash[:notice] = 'Ошибка при создании заявки'
      render :action => "new"
      #redirect_to new_order_tender_path(@order)
    end
  end

  protected

  def find_order
    @order = Order.find(params[:order_id])
  end

end

