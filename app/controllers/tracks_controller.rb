class TracksController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :upload]
  filter_access_to [:new, :create, :upload], :attribute_check => false

  def index
    @tracks = Track.active.find(:all, :order => "id").paginate(page_options)
  end

  def show
    @track = Track.find(params[:id])
    @formats = ["mp3", "doc", "rar", "txt"]
    @file_link = FileLink.new
    @title = @track.fullname
  end

  def new_mp3
    @tracks = Track.active.find(:all, :order => "id DESC").paginate(page_options)
  end

  def top_mp3
    @tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
  end

  # ;;;;;;;;;;;;; Загрузка треков ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  # форма новых треков
  def new
    @playlist = current_user.playlists.find_by_id(params[:playlist_id]) rescue nil
    @tracks = [Track.new]
  end

  # создание треков
  # пытаемся сохранить все треки, если сохранение успешно то отпраляем на треки или в плейлист
  # иначе собираем не валидные треки и выводим по ним ошибочные сообщения
  def create
    @tracks = [] # сюда складываем треки не прошедшие валидацию
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])
    params[:tracks] && for track in params[:tracks]
                         unless track["data"].blank?
                           @track = current_user.tracks.new({ :data => track[:data]})
                           @track.title  = track[:title]  unless track[:title].blank?
                           @track.author = track[:author] unless track[:author].blank?
                           @track.playlists << @playlist if @playlist
                           @tracks << @track unless @track.save
                         end
                       end

    if @tracks.blank? # все треки сохранены
      flash[:notice] = "Отправлено на модерацию"
      redirect_to (@playlist ? admin_playlist_path(@playlist) : admin_tracks_path)
    else
      flash[:error] = 'Error'
      render :action => "new"
    end
  end

  # Загрука по ссылке
  # отправляем в очередь и переходим в треки или в плейлисты
  def upload
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])
    @data_url = params[:data_url]
    @track_urls = URI.extract(@data_url).uniq
    unless @track_urls.blank?
      for track_url in @track_urls
        Delayed::Job.enqueue TrackJob.new track_url, @playlist, current_user
      end
      flash[:notice] = 'Загрузка поставлена в очередь на выполнение'
      redirect_to (@playlist ? admin_playlist_path(@playlist) : admin_tracks_path)
    else
      flash[:error] = 'Error'
      @error_upload = "Ссылки неверного формата"
      render :action => "new"
    end
  end
end

