=begin rdoc
Пополнение баланса через MobilCents
=end
class MobilcentsController < ApplicationController
  before_filter :require_user, :only => [:show]
  skip_before_filter :verify_authenticity_token
  filter_access_to [:show], :attribute_check => false

  # Показываем форму с информации для оплаты и полем ввода пароля.
  def show
    respond_to do |format|
      format.html { }
      format.js { render :action => :show, :layout => false }
    end
  end

  # После того как пользователь отправил смс, на result  приходить запрос что смс отправлена,
  # в ответ мы формируем пароль и отправляем пользователя.
  def result
  end

  # Проверка того что оплата произведена или отменена
  def status
  end

end
