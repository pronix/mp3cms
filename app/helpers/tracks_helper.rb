module TracksHelper

  def link_to_banned(track)
    link_to "Забанить", change_state_admin_track_path(track, :state => "banned"), :id => "banned"
  end

  def link_to_moderate(track)
    link_to "На модерацию", change_state_admin_track_path(track, :state => "moderation"), :id => "moderation"
  end

  def link_to_active(track)
    link_to "Одобрить", change_state_admin_track_path(track, :state => "active"), :id => "active"
  end

  def link_to_download(link, format = nil)
    format = "mp3" unless format
    link_to file_link_url(link.link, format), file_link_url(link.link, format), :id => "my_track_link"
  end

end

