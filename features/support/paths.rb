module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /password_resets\b/
      new_password_reset_path
    when /главной странице сервиса/i
      root_path
    when /Регистрации/i
      signup_path
    when /login/i
      login_path
    when /the new users page/
      new_users_path

    when /news_url/i
      news_items_url

    when /admin_news_items/
      admin_news_items_url

    when /странице управления плейлистами/
      admin_playlists_path
    when /странице управления треками/
      admin_tracks_path
    when /странице админки просмотра плейлиста "([^\"]*)"/
      playlist = Playlist.find_by_title($1)
      admin_playlist_path(playlist)
    when /странице плейлистов/
      playlists_path
    when /странице треков/
      tracks_path
    when /странице просмотра плейлиста "([^\"]*)"/
      playlist = Playlist.find_by_title($1)
      playlist_path(playlist)
    when /поиск по новостям/
      news_items_admin_searches_url
    when /поиск по плейлистам/
      playlists_admin_searches_url
    when /поиск по mp3/
      mp3_admin_searches_url
    when /поиск по пользователей в админке/
      user_admin_searches_url



    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)

