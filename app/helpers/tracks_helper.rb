module TracksHelper

  def link_to_download(link, format = nil)
    format = "mp3" unless format
    link_to format, file_link_url(link.link, format), :id => "track_#{format}"
  end

end

