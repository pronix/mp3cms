class CartsController < ApplicationController
  before_filter :require_user
  before_filter :check_params, :only => :update

  # Просмотр корзины
  #
  def show
  end

  # добавление в корзину
  #
  def add
    current_user.add_to_cart(params[:track_ids])
    respond_to do |format|
      format.html{ redirect_to carts_path }
      format.js { render }
    end

  end

  # Редактирование
  #
  def update
    case params[:bt_action].to_s
    when "archive"
      arhives
    when "destroy"
      current_user.delete_from_cart(params[:track_ids])
      flash.notice = "Треки удалены из корзины"
    end

    redirect_to carts_path
  end

  private

  def arhives
    unless current_user.available_download_track?(params[:track_ids])
      flash[:error] = 'Пополните счет'
    else
      @archive = Archive.create_archive_magick(params[:track_ids], current_user)
      # Генерируем временную ссылку на скачивание
      @archive.generate_archive_link(current_user, request.remote_ip)
      session[:archive] = @archive.id
    end
  end

  def check_params
    if [ params[:track_ids] ].flatten.compact.size <= 0
      flash[:alert] = "Нужно выбрать треки"
      redirect_to carts_path and return
    end
  end
end
