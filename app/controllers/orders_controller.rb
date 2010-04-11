class OrdersController < ApplicationController

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true

  def close_not_found_order
    tender = Tender.find(params[:id])
    if current_user.id == tender.order.user_id      
      order = Order.find(tender.order.id)
      order.update_attribute(:state, "found")
      order.save!
      pforit = Profit.find_by_code("find_track")
      User.pay_for_find(tender.user_id)
      flash[:notice] = "Ордер на поиск был снят, и перенесён в раздел 'сделанно'"
      redirect_to found_orders_url
    else
      flash[:error] = "Вы не являетесь пользователем который выставил ордер на поиск."
      redirect_to :back
    end
    
  end

  def show
    @order = Order.find(params[:id])
    @tenders = @order.tenders.find(:all, :order => "id desc")
  end

  def found
    @orders = Order.find(:all, :conditions => ["state = ?", "found"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def notfoundorders
    @orders = Order.find(:all, :conditions => ["state = ?", "notfound"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
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
    if @order.valid?
      # Пол меняем числовой параметер на строку
      case @order.floor
        when "1"
          @order.update_attribute(:floor, "Мужской")
        when "2"
          @order.update_attribute(:floor, "Женский")
        else
          @order.update_attribute(:floor, "Мужской")
      end

      case @order.music
        when "1"
          @order.update_attribute(:music, "Из кинофильма")
        when "2"
          @order.update_attribute(:music, "Народная песня")
        when "3"
          @order.update_attribute(:music, "Другая")
        else
          @order.update_attribute(:music, "Из кинофильма")
      end

      case @order.language
        when "1"
          @order.update_attribute(:language, "Русский")
        when "2"
          @order.update_attribute(:language, "Английский")
        when "3"
          @order.update_attribute(:language, "Немецкий")
        when "4"
          @order.update_attribute(:language, "Испанский")
        when "5"
          @order.update_attribute(:language, "Итальянский")
        when "6"
          @order.update_attribute(:language, "Французкий")
        when "7"
          @order.update_attribute(:language, "Китайский")
        when "8"
          @order.update_attribute(:language, "Японский")
        when "9"
          @order.update_attribute(:language, "Неопределённый")
        else
          @order.update_attribute(:language, "Русский")
      end

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

