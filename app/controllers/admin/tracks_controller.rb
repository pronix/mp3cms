class Admin::TracksController < Admin::ApplicationController

  before_filter :find_track, :only => [:show, :edit, :update, :destroy, :change_state]
  before_filter :find_user

  def index
    @tracks = @user.admin? ? Track.moderation : @user.tracks
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

  def change_state
    @state = params[:state]
    @track.to_active if @state == "active"
    @track.to_moderation if @state == "moderation"
    @track.to_banned if @state == "banned"
    @track.save
    flash[:notice] = 'Статус трека изменен'
    redirect_to admin_tracks_sort_path("moderation")
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

  def create
    @track = Track.new(params[:track])
    @playlist = Playlist.find params[:track][:playlist_id]
    if @track.save
      build_mp3_tags
      flash[:notice] = 'Трек отправлен на модерацию'
      redirect_to admin_playlist_path(@track.playlist)
    else
      flash[:notice] = 'Ошибка'
      #render :controller => "admin/playlists", :action => "show", :id => @track.playlist.id
      render :action => "new"
    end
  end

  def update
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Трек обновлен'
      redirect_to admin_track_path(@track)
    else
      render :action => "edit"
    end
  end

  def destroy
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_to admin_tracks_path
  end

  def build_mp3_tags
    @data_mp3 = @track.data.path
    Mp3Info.open(@data_mp3, :encoding => 'utf-8') do |mp3|
      @track.title = mp3.tag.title if @track.title.blank?
      @track.author = mp3.tag.artist if @track.author.blank?
      @track.bitrate = mp3.bitrate
      @track.save
    end
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

