class TendersController < ApplicationController

  before_filter :find_order
  filter_access_to [:new, :create]

  def new
    @tender = current_user.tenders.build
    @tenders = @order.tenders.find(:all, :order => "id desc")
  end

  def create
    @tender = current_user.tenders.build(params[:tender])
    @tender.order_id = @order.id
    if @tender.save
      flash[:notice] = 'Заявка принята'
      # Отправляем владельцу заказа сообщение что поступила заявка
      Notifier.deliver_new_tender_message(@order, @order.user.email)
      redirect_to order_path(@order)
    else
      flash[:notice] = 'Ошибка при создании заявки'
      redirect_to new_order_tender_path(@order)
    end
  end

  protected

  def find_order
    @order = Order.find(params[:order_id])
  end

end

