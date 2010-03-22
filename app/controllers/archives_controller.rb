class ArchivesController < ApplicationController

  def create
    #@archive = Archive.new params[:archive]
    @archive = current_user.archives.build

    respond_to do |format|
      if @archive.create_archive_magick(params[:track_ids])
        # Генерируем временную ссылку на скачивание
        @archive.generate_archive_link(current_user, request.remote_ip)
        session[:archive] = @archive.id
        flash[:notice] = "Архив успешно создан. Временная ссылка сгенерирована"
        format.html { redirect_to :back }
        format.js { }
      else
        flash[:notice] = "Ошибка при создании архива"
        format.html { redirect_to :back }
        format.js { @error = true }
      end
    end
  end

  def download

  end

end

