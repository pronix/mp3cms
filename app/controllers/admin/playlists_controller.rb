class Admin::PlaylistsController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:show, :edit, :update, :destroy], :attribute_check => true

  before_filter :find_playlist, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user


  def index
    @playlists = (@user.admin? ? Playlist : @user.playlists).order("id DESC")
    @playlists = @playlists.paginate(page_options(21))
  end

  def new
    @playlist = Playlist.new
  end

  def edit
    @tracks = @playlist.tracks.order("lft ASC")
    load_siblings
  end

  def show
    @comment = Comment.new
    @track = @playlist.tracks.build

    @tracks = @playlist.tracks.paginate(page_options)
    # записываем в сессию список ид треков которые пользователь смошет прослушивать,
    # если треков небудет в списке то при прослушивание выдаеться ответ 404
    session[:listen_track] = @tracks.map(&:id).join(';')
    load_siblings
  end

  # Добавление треков в плейлист
  #
  def to_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.add_tracks(params[:track_ids])

    if @playlist.save
      flash[:notice] = "Выбранные вами треки, успешно добавленны."
    else
      flash[:error]  = @playlist.errors.values.map{|v| "<span>#{v}</span>"}.join.html_safe
    end

    respond_to do |format|
      format.html { redirect_back_or_default(root_path) }
      format.js {  }
    end

  end

  def create
    @playlist = @user.playlists.build(params[:playlist])
    if @playlist.save
      flash[:notice] = 'Плейлист создан'
      redirect_to admin_playlist_path(@playlist)
    else
      flash[:error] = 'Ошибка'
      render :action => "new"
    end
  end

  def update
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = 'Плейлист обновлен'
      redirect_to admin_playlist_path(@playlist)
    else
      render :action => "edit"
    end
  end

  def destroy
    @playlist.destroy
    flash[:notice] = 'Плейлист удален'
    redirect_to admin_playlists_path
  end


  protected

  def find_playlist
    @playlist = current_user.admin? ? Playlist.find(params[:id]) : current_user.playlists.find(params[:id])
  end

  def load_siblings
    @prev_playlist = (current_user.admin? ? Playlist.prev_allow_not_my(@playlist) : Playlist.prev(@playlist)).first
    @next_playlist = (current_user.admin? ? Playlist.next_allow_not_my(@playlist) : Playlist.next(@playlist)).first

  end
end
