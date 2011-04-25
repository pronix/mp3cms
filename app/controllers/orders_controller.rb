class OrdersController < ApplicationController

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true

  def close_not_found_order
    @tender = Tender.find_by_id(params[:id])
    if @tender && current_user == @tender.order.user
      @order = @tender.order
      @order.update_attribute(:state, "found")
      @order.save!
      @tender.user.credit_find_track("Выполнение заказа № #{@order.id}")
      flash[:notice] = "Заказ выполнен и перенесён в раздел 'сделано'"
      redirect_to found_orders_url
    else
      flash[:error] = "Вы не являетесь пользователем который выставил ордер на поиск."
      redirect_to :back
    end

  end

  def show
    @order = Order.find(params[:id])
    @tenders = @order.tenders
    if current_user == @order.user
      @order.tenders.update_all(:state => 'read')
    end
  end

  def found
    @orders = Order.found.paginate(:page => params[:page], :per_page => 10)
  end

  def notfoundorders
    @orders = Order.notfound.paginate(:page => params[:page], :per_page => 10)
  end

  def new

    if current_user.available_order_track?
      @order = current_user.orders.new
    else
      flash[:error] = "Не достаточно денег для создания заказа."
      redirect_to orders_path
    end

  end

  def create
    @order = current_user.orders.build(params[:order])
    unless current_user.available_order_track?
      flash[:error] = "Не достаточно денег для создания заказа."
      redirect_to orders_path and return
    end
    if @order.save
      @order.update_attribute(:state, "notfound")
      # Снятие баланса за создание заказа в столе заказов
      current_user.debit_order_track("Разместили заказ № #{@order.id}")
      flash[:notice] = 'Заказ оформлен'
      redirect_to notfoundorders_orders_path
    else
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


end

