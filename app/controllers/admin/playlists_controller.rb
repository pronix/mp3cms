class Admin::PlaylistsController < Admin::ApplicationController

  before_filter :find_playlist, :only => [:show, :edit, :update, :destroy]

  def index
    #@playlists = @user.playlists
    @playlists = Playlist.all
  end

  def new
    @playlist = Playlist.new
  end

  def edit
  end

  def create
    @playlist = Playlist.new(params[:playlist])
    if @playlist.save
      flash[:notice] = 'Плейлист добавлен'
      redirect_to admin_playlist_path(@playlist)
    else
      render :action => "new"
    end
  end

  def update
    if @playlist.update_attributes(params[:playlist])
      flash[:notice] = 'Плейлист отредактирован'
      redirect_to admin_playlist_path(@playlist)
    else
      render :action => "edit"
    end
  end

  def destroy
    @playlist.destroy
    redirect_to admin_playlists_path
  end

  protected

  def find_playlist
    @playlist = Playlist.find(params[:id])
  end

end

