class Admin::TracksController < Admin::ApplicationController

  before_filter :find_track, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user

  def index
    @tracks = Track.moderation
  end

  def list
    @state = params[:state]
    @tracks = Track.moderation if @state == "moderation"
    @tracks = Track.active if @state == "active"
    @tracks = Track.banned if @state == "banned"
    @tracks = Track.all if @state.blank? || @state == "all"
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def complete
    if params["delete"]
      Track.delete_all :id => params[:track_ids]
    else
      @state = "banned" if params["banned"]
      @state = "active" if params["active"]
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
        track = @playlist.tracks.build params["track_#{index+1}"]
        track.user_id = params[:track][:user_id]
        track.playlists << @playlist
        if track.save
          track.build_mp3_tags
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
    @playlist = Playlist.find params[:playlist_id]
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_to admin_playlist_path @playlist
  end

  protected

  def find_track
    @track = Track.find(params[:id])
  end

  def process_file_uploads(track)
      i = 0
      while params[:track]['data_'+i.to_s] != "" && !params[:track]['data_'+i.to_s].nil?
          Track.new(:data => params[:track]['data_'+i.to_s])
          #build_mp3_tags
          i += 1
      end
  end

end

