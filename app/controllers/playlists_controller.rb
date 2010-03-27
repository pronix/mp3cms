class PlaylistsController < ApplicationController

  filter_access_to :all

  def index
    @playlists = Playlist.all
  end

  def show
    @playlist = Playlist.find(params[:id])
    @comments = @playlist.comments
    @tracks = @playlist.tracks.active.all.paginate(page_options)
    @comment = Comment.new
  end

end

