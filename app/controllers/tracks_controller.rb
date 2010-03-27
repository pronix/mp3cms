class TracksController < ApplicationController

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

end

