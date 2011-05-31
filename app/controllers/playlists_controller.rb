class PlaylistsController < ApplicationController

  filter_access_to :all

  def index
    @playlists = Playlist.order("id DESC").paginate(page_options(40))
  end

  def show
    @playlist = Playlist.find(params[:id])
    @comments = @playlist.comments
    @tracks = @playlist.tracks.active.paginate(page_options)
    @prev_playlist = Playlist.prev_allow_not_my(@playlist).first
    @next_playlist = Playlist.next_allow_not_my(@playlist).first
  end

end

