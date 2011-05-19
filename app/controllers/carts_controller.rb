class CartsController < ApplicationController
  before_filter :require_user

  # Просмотр корзины
  #
  def show
    @user = current_user
    @tracks = @user.cart_tracks.paginate(page_options)
    @archive = Archive.new
    @try_find_archive = ArchiveLink.find(session[:archive]) rescue nil
    session[:archive] = nil unless @try_find_archive
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
      if [params[:track_ids]].flatten.compact.size > 0
        current_user.delete_from_cart(params[:track_ids])
        flash.notice = "Треки удалены из корзины"
      else
        flash[:alert] = "Нужно указать треки"
      end
    end

    redirect_to carts_path
  end

  private

  def arhives
    if [params[:track_ids]].flatten.compact.size > 0

      if params["delete"]
        current_user.delete_from_cart(params[:track_ids])
      else
        unless current_user.available_download_track?(params[:track_ids])
          flash[:error] = 'Пополните счет'
        else
          @archive = current_user.archives.build
          @archive.create_archive_magick(params[:track_ids], current_user)
          # Генерируем временную ссылку на скачивание
          @archive.generate_archive_link(current_user, request.remote_ip)
          session[:archive] = @archive.id
        end
      end

    else
      flash[:error] = "Нужно выбрать треки"
    end

  end

end
