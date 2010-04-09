class TracksController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :upload]
  filter_access_to [:new, :create, :upload], :attribute_check => false

  layout "application", :except => [:ajax_new_mp3, :ajax_top_mp3]

  def my
    @tracks = current_user.tracks.find(:all, :conditions => ["state = ? or state = ?", "moderation", "active"] ).paginate(page_options)
    render :action => "index"
  end

  def index
    if current_user
        @tracks = current_user.tracks.find(:all, :conditions => ["state = ? or state = ?", "moderation", "active"] ).paginate(page_options)
        @tracks = Track.active.find(:all, :order => "id").paginate(page_options) if @tracks.empty?
    else
        @tracks = Track.active.find(:all, :order => "id").paginate(page_options)
    end
  end

  def author
    @tracks = Track.active.find(:all, :order => "id", :conditions => ["author = ?", params[:author]]).paginate(page_options)
    render :action => "index"
  end

  def show
    @track = Track.find(params[:id])
    @file_formats = ["mp3", "doc", "rar", "txt"]
    @file_link = FileLink.new
    @title = @track.fullname
    respond_to do |format|
      format.html{ }
      format.js { render :action => "show", :layout => false }
    end
  end

  def play
    @track = Track.find params[:id]
    @hash_link = SecureRandom.hex(20)
    @temp_url = "play_track/#{@hash_link}"
    @length = Mp3Info.open(@track.data.path).length rescue 0

    session[:play_links] ||= { }
    session[:play_links][@hash_link] = { :time => (Time.now+30.minutes).to_i, :id => @track.id }
  end

  def new_mp3
    @tracks = Track.active.find(:all, :order => "id DESC").paginate(page_options)
  end

  def ajax_new_mp3
    if params[:q].blank?
      @tracks = Track.active.find(:all, :order => "id DESC").paginate(page_options)
    else
      @tracks = Track.active.find(:all, :order => "id DESC").paginate(:per_page => params[:q], :page => params[:page])
    end

    render :action => :new_mp3
  end

  def top_mp3
    #@tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
    @tracks = Track.top_mp3(20).paginate(page_options)
  end

  def ajax_top_mp3
    @tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
    render :action => :top_mp3
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
                         else
                           @track = Track.new
                           @track.errors.add_to_base("Нужно выбрать файл")
                           @tracks << @track
                         end
                       end

    if @tracks.blank?   # все треки сохранены
      flash[:notice] = "Отправлено на модерацию"
      if current_user.admin?
        redirect_to admin_tracks_url
      else
        redirect_to my_tracks_path
      end
    else
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

