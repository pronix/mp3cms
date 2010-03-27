class ArchivesController < ApplicationController

  def create
    respond_to do |format|
      if params[:track_ids].to_a.size > 0
        if params["delete"]
          current_user.delete_from_cart(params[:track_ids])
        else
          @archive = current_user.archives.build
          @archive.create_archive_magick(params[:track_ids])
          # Генерируем временную ссылку на скачивание
          @archive.generate_archive_link(current_user, request.remote_ip)
          #current_user.debit_download_track("Скачали трек")
          session[:archive] = @archive.id
          #flash[:notice] = "Архив успешно создан. Временная ссылка сгенерирована"
        end
        format.html { redirect_to :back }
        format.js { }
      else
        #flash[:notice] = "Ошибка при создании архива"
        format.html { redirect_to :back }
        format.js { @error = true }
      end
    end
  end

  def download
    # См. lib/download.rb
  end

end

