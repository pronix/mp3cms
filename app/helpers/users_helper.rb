module UsersHelper

  def link_to_archive_link_of(archive_id)
    link = ArchiveLink.find(:first, :conditions => {:user_id => current_user.id, :archive_id => archive_id})
    link_to archive_link_url(link.link), archive_link_url(link.link), :id => "my_archive_link"
  end

end

