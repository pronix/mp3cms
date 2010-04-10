class OrdersController < ApplicationController

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy, :found, :notfound], :attribute_check => true

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

  def notfoundorders
    @orders = Order.find(:all, :conditions => ["state = ?", "notfound"], :order => "created_at DESC")
  end

  def new
    if current_user.balance > 0
      @order = current_user.orders.new
    else
      flash[:notice] = "У вас должен быть положительный баланс, прежде чем вы сможете делать заказы."
      redirect_to root_url
    end
  end

  def create
    @order = current_user.orders.build(params[:order])
    @order.update_attribute(:state, "notfound")
    if @order.save
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

