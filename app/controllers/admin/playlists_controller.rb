class Admin::PlaylistsController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:show, :edit, :update, :destroy], :attribute_check => true

  before_filter :find_playlist, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user

  def index
    @playlists = @user.admin? ? Playlist.find(:all, :order => "id DESC") : @user.playlists.find(:all, :order => "id DESC")
    @playlists = @playlists.paginate(page_options(21))
  end

  def new
    @playlist = Playlist.new
  end

  def edit
    @tracks = @playlist.tracks.find(:all, :order => "lft ASC")
    @prev_playlist = (current_user.admin? ? Playlist.prev_allow_not_my(@playlist) : Playlist.prev(@playlist)) rescue nil
    @next_playlist = (current_user.admin? ? Playlist.next_allow_not_my(@playlist) : Playlist.next(@playlist)) rescue nil
  end

  def show
    @comment = Comment.new
    @track = @playlist.tracks.build

    @tracks = @playlist.tracks.all.paginate(page_options)
    # записываем в сессию список ид треков которые пользователь смошет прослушивать,
    # если треков небудет в списке то при прослушивание выдаеться ответ 404
    session[:listen_track] = @tracks.map(&:id).join(';')
    @prev_playlist = (current_user.admin? ? Playlist.prev_allow_not_my(@playlist) : Playlist.prev(@playlist)) rescue nil
    @next_playlist = (current_user.admin? ? Playlist.next_allow_not_my(@playlist) : Playlist.next(@playlist)) rescue nil
  end

  def to_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.add_tracks(params[:track_ids])

    respond_to do |format|
      if @playlist.save
        format.html { redirect_back_or_default(root_path) }
        format.js { }
      else
        format.html { redirect_back_or_default(root_path) }
        format.js { @error = true }
      end
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
    params[:playlist][:track_ids] ||= []
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

  def to_cart

    @user.add_to_cart(params[:track_ids])

    respond_to do |format|
      format.html { redirect_back_or_default(root_path) }
      format.js { }
    end
  end

  def to_cart_from_playlist

    @user.add_to_cart(params[:track_ids])
    flash[:notice] = "Треки успешно добавлены в корзину"
    respond_to do |format|
      format.html { redirect_back_or_default(root_path) }
      format.js { }
    end
  end

  protected

  def find_playlist
    @playlist = current_user.admin? ? Playlist.find(params[:id]) : current_user.playlists.find(params[:id])
  end

end
