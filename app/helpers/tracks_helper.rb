module TracksHelper

  def link_to_download(link, format = nil)
    format = "mp3" unless format
    link_to file_link_url(link.link, format), file_link_url(link.link, format), :id => "my_track_link"
  end

end

