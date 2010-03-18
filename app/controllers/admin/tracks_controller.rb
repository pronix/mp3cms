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

  def create
    @data_url = params[:track][:data_url]
    @playlist = Playlist.find params[:track][:playlist_id]
    #if @data_url
    #  send_later :upload_tracks @data_url
    #else
                Array.new(10).each_index do |index|
                  unless params["track_#{index+1}"].blank?
                    track = Track.new params["track_#{index+1}"]
                    track.user_id = params[:track][:user_id]
                    track.playlist_id = params[:track][:playlist_id]
                    if track.save
                      build_mp3_tags track
                    end
                  end
                end
    #end
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
    @playlist = @track.playlist
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_to admin_playlist_path @playlist
  end

  def build_mp3_tags(track)
    data_mp3 = track.data.path
    Mp3Info.open(data_mp3, :encoding => 'utf-8') do |mp3|
      unless mp3.tag.title.blank? && mp3.tag.artist.blank? && mp3.bitrate < 128
        track.title = mp3.tag.title if track.title.blank?
        track.author = mp3.tag.artist if track.author.blank?
        track.bitrate = mp3.bitrate
        track.save
      else
        track.destroy
      end
    end
    flash[:notice] = "Отправлено на модерацию"
  end

  protected

  # добавление в очередь задания для загрузки файлов по ссылке
  def upload_tracks(data_url_text)

  end

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

