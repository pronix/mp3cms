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
      Notification.new_tender_message(@order, @order.user.try(:email)).deliver
      redirect_to notfoundorders_orders_path, :notice => 'Комментарий отправлен на модерацию.'
    else
      flash[:notice] = 'Ошибка при создании заявки'
      render :action => "new"
    end
  end

  protected

  def find_order
    @order = Order.find(params[:order_id])
  end

end

