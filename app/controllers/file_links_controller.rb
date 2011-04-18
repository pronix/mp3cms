class FileLinksController < ApplicationController

  before_filter :require_user
  before_filter :find_user

  def generate
    @track = Track.find params[:track_id]

    unless current_user.available_download_track?
      flash[:notice] = 'Пополните счет'
      redirect_to track_path @track
    else

      if (@file_link = @track.build_link(current_user, request.remote_ip)) && @file_link.save
        # увеличиваем счетчик скачиваний трека на 1
        @file_link.track.recount_top_download

        # Добавляем трек в таблицу скаченных(тужна для Топ mp3)
        LastDownload.add_download_track(params[:track_id])
        User.add_one_download(current_user.id)
        flash[:notice] = 'Ссылка успешно создана'
        redirect_to track_path @track
      else
        redirect_to track_path @track
      end



    end


  end

  def download
    # Загрузка трека по временной ссылке, см. lib/download.rb
  end

end

