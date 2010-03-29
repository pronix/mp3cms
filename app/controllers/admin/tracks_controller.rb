class Admin::TracksController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:show, :edit, :update, :destroy], :attribute_check => true
  before_filter :find_track, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user

  def index
    @tracks = Track.moderation.find(:all, :order => "id DESC").paginate(page_options)
  end

  def list
    @state = params[:state]
    @tracks = Track.moderation if @state == "moderation"
    @tracks = Track.active if @state == "active"
    @tracks = Track.banned if @state == "banned"
    @tracks = Track.all if @state.blank? || @state == "all"
    @tracks = @tracks.find(:all, :order => "id DESC").paginate(page_options)
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def abuza
    links = params[:track_links]
    @tracks = []
    if links || session[:abuza_track_links]
      if links
        track_links = URI.extract(links).uniq
      else
        track_links = session[:abuza_track_links]
      end
      track_links.each do |track_link|
        track_id = track_link.split("/").last
        track = Track.find(track_id) rescue nil
        @tracks << track if track
      end
      if @tracks.size > 0
        @tracks.paginate(page_options)
        flash[:notice] = 'Таблица создана'
      else
        flash[:notice] = 'Таблица пуста'
      end
    end
  end

  def save_in_session
    session[:abuza_track_links] = params["abuza_track_links"]
    flash[:notice] = 'Сохранено в памяти'
    redirect_to abuza_admin_tracks_path
  end

  def clear_from_session
    session[:abuza_track_links] = ''
    flash[:notice] = 'Стерто из памяти'
    redirect_to abuza_admin_tracks_path
  end

  def complete
    if params["delete"]
      Track.delete_all :id => params[:track_ids]
    else
      if params["active"]
        @state = "active"
        credit_upload_track(params[:track_ids])
      end
      if params["banned"]
        @state = "banned"
        make_hash_for_ban(params[:track_ids])
      end
      Track.update_all ["state=?", @state], :id => params[:track_ids] if @state
    end
    redirect_to admin_tracks_path
  end

  def show
  end

  def upload
    @data_url = params[:data_url]
    @playlist = Playlist.find params[:playlist_id]
    @track_urls = URI.extract(@data_url).uniq
    for track_url in @track_urls
      Delayed::Job.enqueue TrackJob.new track_url, @playlist, @user
    end
    flash[:notice] = 'Загрузка поставлена в очередь на выполнение'
    redirect_to admin_playlist_path @playlist
  end

  def create
    @data_url = params[:track][:data_url]
    @playlist = Playlist.find params[:playlist_id]
    Array.new(10).each_index do |index|
      unless params["track_#{index+1}"].blank?
        @track = @playlist.tracks.build params["track_#{index+1}"]
        @track.user_id = params[:track][:user_id]
        @track.playlists << @playlist
        if @track.save
          @track.build_mp3_tags
        end
      end
    end
    flash[:notice] = "Отправлено на модерацию"
    redirect_to admin_playlist_path @playlist
  end

  def update
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Трек обновлен'
      redirect_to admin_tracks_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_to :back
  end

  def credit_upload_track(params_track_ids)
    tracks = Track.find(params_track_ids)
    users = []
    tracks.each do |track|
      user = User.find(track.user_id)
      users << user if user
    end
    users.each do |user|
      # Пополнение баланса за загрузку нормального трека
      user.credit_upload_track("Загружен трек")
    end
  end

  def make_hash_for_ban(params_track_ids)
    tracks = Track.find(params_track_ids)
    for track in tracks
      ban_track = BanTrack.create!(:check_sum => track.check_sum)
    end
  end

  protected

  def find_track
    @track = Track.find(params[:id])
  end

end

