class Admin::SearchesController < ApplicationController

  layout "admin"

# default_behavior в в аргументе метода search говорит о том что мы вышли на страницу без дололнительных аргументов и по дефолту произойдёт выборка "список треков на модерации"
  def show
    case params[:model]
      when "Track"
        @rez_search = Track.search_track(params)
      else
        @rez_search = Track.search_track("default")
    end

    render :partial => "item"

  end


end

