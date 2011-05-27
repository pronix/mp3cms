class Admin::TracksController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy, :delete_from_playlist], :attribute_check => true
  before_filter :find_track, :only => [ :edit, :update, :destroy, :delete_from_playlist]
  before_filter :find_playlist_and_track_objects, :only => [:move_up, :move_down]
  before_filter :find_user

  def index
    @tracks = Track.search_moderation(page_options) # moderation.order("id DESC").paginate(page_options)
  end

  def list
    @tracks = case params[:state]
              when /moderation/ then Track.moderation
              when /active/     then Track.active
              when /banned/     then Track.banned
              else
                Track.all
              end.paginate(page_options)
  end

  def new
    @track = Track.new
  end

  def edit
    respond_to do |format|
      format.html{ }
      format.js { render :action => "edit", :layout => false }
    end
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
        @track = @playlist.tracks.build({:data =>params["track_#{index+1}"][:data]})
        @track.title = params["track_#{index+1}"][:title] unless params["track_#{index+1}"][:title].blank?
        @track.author = params["track_#{index+1}"][:author] unless params["track_#{index+1}"][:author].blank?
        @track.user_id = params[:track][:user_id]
        # @track.playlists << @playlist
        if @track.save
          # @track.build_mp3_tags
        end
      end
    end

    flash[:notice] = "Отправлено на модерацию"
    redirect_to admin_playlist_path @playlist
  end

  def move_up
		#@playlist_track.move_left
    @prev_playlist_track = PlaylistTrack.find(:first, :conditions => "lft < #{@playlist_track.lft}")

    if @prev_playlist_track
		  @playlist_track.move_to_left_of(@prev_playlist_track.id)
      @tracks = @playlist.tracks.find(:all, :order => "lft ASC")
      respond_to do |format|
        format.html { redirect_to edit_admin_playlist_path(@playlist) }
        format.js { }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_admin_playlist_path(@playlist) }
        format.js { @error = true }
      end
    end
  end

  def move_down
		#@playlist_track.move_right
    @next_playlist_track = PlaylistTrack.find(:first, :conditions => "lft > #{@playlist_track.lft}")

    if @next_playlist_track
		  @playlist_track.move_to_right_of(@next_playlist_track.id)
      @tracks = @playlist.tracks.find(:all, :order => "lft ASC")
      respond_to do |format|
        format.html { redirect_to edit_admin_playlist_path(@playlist) }
        format.js { }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_admin_playlist_path(@playlist) }
        format.js { @error = true }
      end
    end
  end

  def delete_from_playlist
    if @playlist = (current_user.admin? ? Playlist : current_user.playlists).find_by_id(params[:playlist_id])
      @playlist_track = PlaylistTrack.where(:track_id => @track.id, :playlist_id => @playlist.id).first
      @playlist_track.destroy
    end

    respond_to do |format|
      format.html { redirect_to edit_admin_playlist_path(@playlist) }
      format.js { }
    end
  end

  def update
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Трек обновлен'
      redirect_to track_path(@track)
    else
      render :action => "edit"
    end
  end

  def destroy
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_back_or_default(tracks_path)
  end

  def credit_upload_track(params_track_ids)
    unless params_track_ids.blank?
      tracks = Track.find(params_track_ids)
      users = []
      tracks.each do |track|
        if track.was_paid == false
          user = User.find(track.user_id)
          users << user if user
          track.update_attribute(:was_paid, true)
          track.save
        end
      end
      users.each do |user|
        # Пополнение баланса за загрузку нормального трека
        user.credit_upload_track("Скачен трек")
      end
    end
  end

  def make_hash_for_ban(params_track_ids)
    unless params_track_ids.blank?
      tracks = Track.find(params_track_ids)
      for track in tracks
        ban_track = BanTrack.create!(:check_sum => track.check_sum)
      end
    end
  end

  protected

  def find_track
    @track = Track.find(params[:id])
  end

  def find_playlist_and_track_objects
    @track = Track.find(params[:track_id])
    @playlist = Playlist.find(params[:playlist_id])
    @playlist_track = PlaylistTrack.where(:track_id => @track.id, :playlist_id => @playlist.id).first
  end

end

