class ArchivesController < ApplicationController

  before_filter :require_user

  def create
    respond_to do |format|
      if params[:track_ids].to_a.size > 0
        if params["delete"]
          current_user.delete_from_cart(params[:track_ids])
        else
          @archive = current_user.archives.build
          @archive.create_archive_magick(params[:track_ids], current_user)
          # Генерируем временную ссылку на скачивание
          @archive.generate_archive_link(current_user, request.remote_ip)
          session[:archive] = @archive.id
        end
        format.html { redirect_to cart_path }
        format.js { }
      else
        format.html { redirect_to cart_path }
        format.js { @error = true }
      end
    end
  end

  def download
    # См. lib/download.rb
  end

end

