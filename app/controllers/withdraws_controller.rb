class WithdrawsController < ApplicationController
  before_filter :require_user
  filter_access_to :all, :attribute_check => false

  # Выводм форму для вывода денег
  def new
   @transaction = current_user.transactions.new
    respond_to do |format|
      format.html
      format.js { render :action => :new, :layout => false }
    end
  end

  # Создаем транзакцию для вывода денег
  def create
    @amount =params[:withdraw] && params[:withdraw][:amount] && (Kernel.Float(params[:withdraw][:amount]) rescue nil )

    if @amount && current_user.can_withdraw(@amount) && (@transaction = current_user.transactions.withdraw(@amount))
      flash[:notice] = "Заявка № #{@transaction.id} принята."
      respond_to do |format|
        format.html { redirect_to payments_path }
        format.js   { render :text => flash[:notice] }
      end
    else
      flash[:amount_error] =
        unless current_user.errors.blank?
          ['<ul>',current_user.errors.full_messages.map{|x| "<li>#{x}</li>" }, '</ul>'].flatten.join
        else
          "Не правильная сумма."
        end
      respond_to do |format|
        format.html { render :action => :new }
        format.js { render :text => flash[:amount_error], :status => :internal_server_error }
      end
    end

  end

end
