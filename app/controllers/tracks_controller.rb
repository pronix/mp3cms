class TracksController < ApplicationController
  before_filter :require_user, :only => [:new, :create]
  def index
    @tracks = Track.active.find(:all, :order => "id").paginate(page_options)
  end

  def show
    @track = Track.find(params[:id])
    @formats = ["mp3", "doc", "rar", "txt"]
    @file_link = FileLink.new
    @title = @track.fullname
  end

  def new_mp3
    @tracks = Track.active.find(:all, :order => "id DESC").paginate(page_options)
  end

  def top_mp3
    @tracks = Track.active.find(:all, :order => "count_downloads DESC").paginate(page_options)
  end

  # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  def new
    @playlist = current_user.playlists.find_by_id(params[:playlist_id])
    @tracks = [@playlist ? @playlist.tracks.new : current_user.tracks.new]
  end

  def create
    @tracks = []
    @playlist = current_user.playlists.find_by_id(params[:playlist_id])
    params[:tracks] &&
      for track in params[:tracks]
        unless track["data"].blank?
          @track = (@playlist ? @playlist : current_user).tracks.build(track)
          @tracks << @track unless @track.save
        end
      end

    if @tracks.blank? # все треки сохранены
      flash[:notice] = 'Successfully'
      redirect_to admin_tracks_path
    else
      flash[:error] = 'Error'
      render :action => "new"
    end
  end

end

