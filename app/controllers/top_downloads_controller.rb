class TopDownloadsController < ApplicationController

  def index
    @top_dowloads = TopDownload.find(:all, :order => "count_downloads DESC", :limit => 5000).paginate(page_options)
  end

end

