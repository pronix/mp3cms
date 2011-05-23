class AddMissingIndexes < ActiveRecord::Migration

  def self.up
    add_index :tenders, :order_id
    add_index :tenders, :user_id
    add_index :transactions, :user_id
    add_index :playlist_tracks, :parent_id
    add_index :playlist_tracks, :track_id
    add_index :playlist_tracks, :playlist_id
    add_index :news_items, :user_id
    add_index :newsimages, :news_item_id
    add_index :file_links, :track_id
    add_index :file_links, :user_id
    add_index :assets, [:id, :type]
    add_index :playlists, :user_id
    add_index :cost_countries, :gateway_id
    add_index :last_downloads, :track_id
    add_index :orders, :user_id
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
    add_index :users, :referrer_id
    add_index :tracks, :satellite_id
    add_index :sms_payments, :user_id
    add_index :archive_links, :archive_id
    add_index :archive_links, :user_id
    add_index :archives, :user_id
    add_index :cart_tracks, :track_id
    add_index :cart_tracks, :user_id
    add_index :check_tenders, :tender_id
    add_index :check_tenders, :user_id
    add_index :users, [:ban, :type_ban, :current_login_ip ]
  end

  def self.down
    remove_index :tenders, :order_id
    remove_index :tenders, :user_id
    remove_index :transactions, :user_id
    remove_index :playlist_tracks, :parent_id
    remove_index :playlist_tracks, :track_id
    remove_index :playlist_tracks, :playlist_id
    remove_index :news_items, :user_id
    remove_index :newsimages, :news_item_id
    remove_index :file_links, :track_id
    remove_index :file_links, :user_id
    remove_index :assets, :column => [:id, :type]
    remove_index :playlists, :user_id
    remove_index :cost_countries, :gateway_id
    remove_index :last_downloads, :track_id
    remove_index :orders, :user_id
    remove_index :roles_users, :column => [:role_id, :user_id]
    remove_index :roles_users, :column => [:user_id, :role_id]
    remove_index :users, :referrer_id
    remove_index :tracks, :satellite_id
    remove_index :sms_payments, :user_id
    remove_index :archive_links, :archive_id
    remove_index :archive_links, :user_id
    remove_index :archives, :user_id
    remove_index :cart_tracks, :track_id
    remove_index :cart_tracks, :user_id
    remove_index :check_tenders, :tender_id
    remove_index :check_tenders, :user_id
    remove_index :users, [:ban, :type_ban, :current_login_ip ]
  end



end
