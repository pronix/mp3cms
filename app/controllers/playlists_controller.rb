class PlaylistsController < ApplicationController

  def index
    @playlists = Playlist.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
    @comments = @playlist.comments
    @comment = Comment.new
  end

end

