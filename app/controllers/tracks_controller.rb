class TracksController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :upload]
  filter_access_to [:new, :create, :upload], :attribute_check => false

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
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])
    params[:tracks] && for track in params[:tracks]
                         unless track["data"].blank?
                           @track = current_user.tracks.build(track)
                           @track.playlists << @playlist if @playlist
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

  def upload
    @playlist = params[:playlist_id].blank? ? nil : current_user.playlists.find_by_id(params[:playlist_id])
    @data_url = params[:data_url]
    @track_urls = URI.extract(@data_url).uniq
    unless @track_urls.blank?
      for track_url in @track_urls
        Delayed::Job.enqueue TrackJob.new track_url, @playlist, current_user
      end
      flash[:notice] = 'Загрузка поставлена в очередь на выполнение'
      redirect_to admin_playlist_path @playlist
    else
      flash[:error] = 'Error'
      @error_upload = "Ссылки неверного формата"
      render :action => "new"
    end
  end
end

