class OrdersController < ApplicationController

  before_filter :find_order, :only => [:show, :edit, :update, :destroy, :found, :notfound]
  filter_access_to :all
  filter_access_to [:edit, :update, :destroy, :found, :notfound], :attribute_check => true

  def index
    @orders = Order.find(:all, :order => "id desc").paginate(page_options)
    @order = current_user.orders.new
  end

  def show
    @tenders = @order.tenders.find(:all, :order => "id desc")
  end

  def found
    @order.to_found
    @tender = Tender.find(params[:tender_id])
    @tender.complete = true
    @worker = User.find(@tender.user_id)
    if @tender.save && @order.save
      # Пополнение баланса за выполнение задания в столе заказов
      @worker.credit_find_track("Заявка № #{@tender.id} принята")
      flash[:notice] = 'Заявка подтверждена'
      redirect_to order_path(@order)
    end
  end

  def notfound
    @order.to_notfound
    @tender = Tender.find(params[:tender_id])
    @tender.complete = false
    if @tender.save && @order.save
      flash[:notice] = 'Заявка отклонена'
      redirect_to order_path(@order)
    end
  end

  def new
    @order = current_user.orders.new
  end

  def create
    @order = current_user.orders.build(params[:order])
    if @order.save
      # Снятие баланса за создание заказа в столе заказов
      current_user.debit_order_track("Разместили заказ № #{@order.id}")
      flash[:notice] = 'Заказ оформлен'
      redirect_to order_path(@order)
    else
      flash[:notice] = 'Ошибка'
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @order.update_attributes(params[:order])
      flash[:notice] = 'Заказ обновлен'
      redirect_to order_path(@order)
    else
      render :action => "edit"
    end
  end

  def destroy
    @order.destroy
    flash[:notice] = 'Заказ удален'
    redirect_to orders_path
  end

  protected

  def find_order
    @order = Order.find(params[:id])
  end

end

