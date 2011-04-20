module TracksHelper

  def link_to_download(link, format = nil)
    format = "mp3" unless format
    if Rails.env =~ /production/ && link.track.satellite
      satelliteurl = 'http://' + link.track.satellite.domainname  + '/download/' + link.link + ".#{format}"
    else
      satelliteurl ='/download/' + link.link + ".#{format}"
    end
    link_to format, satelliteurl , :id => "track_#{format}"
  end

end

