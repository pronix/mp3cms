module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /edit_admin_profits\b/
      edit_admin_profits_path
    when /admin_profits\b/
      admin_profits_path
    when /admin_users/
      admin_users_path
    when /user_sessions/
      user_sessions_path
    when /new_admin_role/
      new_admin_role_path
    when /admin_roles/
      admin_roles_path
    when /password_resets\b/
      new_password_reset_path
    when /главной странице сервиса/i
      root_path
    when /Регистрации/i
      signup_path
    when /login/i
      login_path
    when /the home\s?page/
      '/'
    when /the new server_statistic page/
      new_server_statistic_path

    when /the new serevr_state page/
      new_serevr_state_path

    when /the new app_settings page/
      new_app_settings_path

    when /главной странице/
      '/'

    when /the new users page/
      new_users_path
    when /account_path/
      account_path
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
    when /странице управления комментариями/
      admin_comments_path
    when /странице управления абузами/
      abuza_admin_tracks_path
    when /странице админки просмотра плейлиста "([^\"]*)"/
      playlist = Playlist.find_by_title($1)
      admin_playlist_path(playlist)
    when /странице админки редактирования плейлиста "([^\"]*)"/
      playlist = Playlist.find_by_title($1)
      edit_admin_playlist_path(playlist)
    when /странице плейлистов/
      playlists_path
    when /странице стола заказов/
      new_order_path
    when /странице просмотра заказа "([^\"]*)"/
      order = Order.find_by_title($1)
      order_path(order)
    when /странице треков/
      tracks_path
    when /странице просмотра плейлиста "([^\"]*)"/
      playlist = Playlist.find_by_title($1)
      playlist_path(playlist)
    when /странице просмотра трека "([^\"]*)"/
      track = Track.find_by_title($1)
      track_path(track)
    when /payments\b/
      payments_path
    when /странице скачивания файла "([^\"]*)"/
      track = Track.find_by_title($1)
      track_path(track)
    when /странице трека "([^\"]*)"/
      track = Track.find($1)
      track_path(track)
    when /страницу нарезки для трека "([^\"]*)"/
      track = Track.find($1)
      mp3_cut_path(track)
    when /категории новостей/
      admin_news_categories_path
    when /admin_gateways\b/
      admin_gateways_path
    when /admin_payouts\b/
      admin_payouts_path
    when /admin_transactions\b/
      admin_transactions_path
    when /поиск в админке\b/
      admin_searches_url
    when /поиск пользователей в админке\b/
      admin_searches_path(:model => "user")
    when /поиск транзакции в админке\b/
      admin_searches_path(:model => "transaction")
    when /поиск плейлистов в админке\b/
      admin_searches_path(:model => "playlist")
    when /поиск новостей в админке\b/
      admin_searches_path(:model => "news_item")
    when /admin_pages\b/
      admin_pages_path
    when /about\b/i
      "/about"
    when /abountd\b/i
      "/abountd"
    when /admin_settings\b/i
      admin_settings_path
    when /странице топа скачиваемых файлов/
      top_mp3_tracks_path
    when /admin_servers\b/
      admin_servers_path
    when /странице корзины/
      cart_path
    when /странице новостей/
      news_items_path
    when /странице управление серверами/
      admin_satellites_url
    when /не найденно в столе заказов/
      notfoundorders_orders_url

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

