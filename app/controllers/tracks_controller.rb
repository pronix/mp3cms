class TracksController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :upload, :my_on_moderation_mp3, :my_active_mp3, :my]
  filter_access_to [:new, :create, :upload], :attribute_check => false

  layout "application", :except => [:ajax_new_mp3, :ajax_top_mp3, :my_active_mp3, :my_on_moderation_mp3]

  def top_100
    @tracks = Track.top_mp3(100).paginate(page_options)
  end


  def index
    if current_user
      @tracks =
        case params[:state].to_s
        when "fresh"      # новые треки
        when "my"         # мои треки
          current_user.tracks.not_banned.paginate(page_options)
        when "moderation" #  на модерирование
          current_user.tracks.moderation.order("count_downloads DESC").paginate(page_options)
        when "active"     # актывные
          current_user.tracks.active.order("count_downloads DESC").paginate(page_options)
        end
    end

    @tracks ||= Track.active.paginate(page_options)
    respond_to do |format|
      format.html{ }
      format.js{ render :action => :index, :layout => false  }
    end
  end

  def ajax_new_mp3
    if params[:q].blank?
      @tracks = Track.active.all(:order => "id DESC").paginate(page_options)
    else
      @tracks = Track.active.all(:order => "id DESC").paginate(:per_page => params[:q], :page => params[:page])
    end
    render :action => :new_mp3
  end

  def author
    @tracks =
      if params[:author].blank?
        Track.active.paginate(page_options)
      else
        Track.active.where(:author_id => Track.to_author_id(params[:author])).order("title").paginate(page_options)
      end
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

  def new_mp3_for_main
    @tracks = Track.active.find(:all, :order => "updated_at DESC").paginate(page_options)
    respond_to do |format|
      format.html{ }
      format.js { render :action => "new_mp3_for_main", :layout => false }
    end

  end

  def top_mp3
    @tracks = Track.top_mp3(20).paginate(page_options)
  end

  def top_mp3_for_main
    @tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
    respond_to do |format|
      format.html{ render :action => "new_mp3_for_main" }
      format.js { render :action => "new_mp3_for_main", :layout => false }
    end
  end

  def ajax_top_mp3
    @tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
    render :action => :top_mp3
  end


  # ;;;;;;;;;;;;; Загрузка треков ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  # форма новых треков
  def new
    @playlist = current_user.playlists.find_by_id(params[:playlist_id]) || current_user.playlists.first
    @tracks = [ Track.new ]
  end

  # создание треков
  # пытаемся сохранить все треки, если сохранение успешно то отпраляем на треки или в плейлист
  # иначе собираем не валидные треки и выводим по ним ошибочные сообщения
  def create
    @tracks = [] # сюда складываем треки не прошедшие валидацию
    @success_tracks = [] # треки которые сохранены
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])

    if params[:tracks].blank?
      flash[:notice] = "Нужно указать файл"
      render :action => "new" and return
    end

    @satellite = Satellite.find_by_master(true)
    unless @satellite
      flash[:notice] = "Извините но сервис загрузки музыки временно не доступен, повторите попытку через несколько минут"
      redirect_to root_url
    else
      params[:tracks] &&
        params[:tracks].each do |track|
        unless track["data"].blank?
          @track = current_user.tracks.new({ :data => track[:data]})
          @track.title  = track[:title]  unless track[:title].blank?
          @track.author = track[:author] unless track[:author].blank?
          @track.playlists << @playlist if @playlist
          @track.satellite_id = @satellite.id
          (@track.save ? @success_tracks : @tracks) << @track
        else
          @track = Track.new
          @track.errors.add_to_base("Нужно выбрать файл")
          @tracks << @track
        end
      end

      if @tracks.blank?  # все треки сохранены
        flash[:notice] = "Отправлено на модерацию"
        redirect_to (current_user.admin? ? admin_tracks_url : state_tracks_path(:my))
      else
        render :action => "new"
      end

    end
  end

  # Загрука по ссылке
  # отправляем в очередь и переходим в треки или в плейлисты
  def upload
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])
    @data_url = params[:data_url]
    @track_urls = URI.extract(@data_url).uniq
    unless @track_urls.blank?
      @track_urls.each { |track_url|
        Track.send_later(:remote_upload, {
                           :email => current_user.email,
                           :user => current_user,
                           :track_url => track_url,
                           :playlist =>  @playlist })
      }
      flash[:notice] = 'Загрузка поставлена в очередь на выполнение'
      redirect_to (@playlist ? playlist_path(@playlist) : state_tracks_path(:my))
    else
      flash[:error] = 'Ссылки неверного формата'
      @error_upload = "Ссылки неверного формата"
      render :action => "new"
    end

  end
end

