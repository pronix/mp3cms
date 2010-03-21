class Admin::PlaylistsController < Admin::ApplicationController

  before_filter :find_playlist, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user

  def index
    @playlists = @user.admin? ? Playlist.all : @user.playlists
  end

  def new
    @playlist = Playlist.new
  end

  def edit
  end

  def show
    @comment = Comment.new
    @track = @playlist.tracks.build
    @tracks = @playlist.tracks.all
  end

  def complete
    params[:playlist][:track_ids] ||= []
    @playlist = Playlist.find(params[:playlist_id])

    respond_to do |format|
      if @playlist.update_attributes(params[:playlist])
        flash[:notice] = 'Успешно обновлено!'
        format.html { redirect_to root_path }
        format.js
      else
        format.html { render :action => "edit" }
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
      flash[:notice] = 'Ошибка'
      render :controller => "admin/playlists", :action => "show", :id => @playlist.id
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

  protected

  def find_playlist
    @playlist = Playlist.find(params[:id])
  end

end

