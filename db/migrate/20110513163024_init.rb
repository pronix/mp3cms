class Init < ActiveRecord::Migration
  def self.up

    create_table "app_settings" do |t|
      t.string   "code",       :null => false
      t.string   "name",       :null => false
      t.string   "value",      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "app_settings", ["code"], :name => "index_app_settings_on_code"

    create_table "archive_links" do |t|
      t.integer  "archive_id"
      t.integer  "user_id"
      t.integer  "speed"
      t.string   "file_name",    :null => false
      t.string   "file_path",    :null => false
      t.string   "file_size",    :null => false
      t.string   "content_type", :null => false
      t.string   "link",         :null => false
      t.string   "ip",           :null => false
      t.datetime "expire",       :null => false
      t.string   "state",        :null => false
    end

    create_table "archives" do |t|
      t.string   "data_file_name"
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.datetime "data_updated_at"
      t.integer  "user_id"
    end

    create_table "assets" do |t|
      t.string   "data_file_name"
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.integer  "assetable_id"
      t.string   "assetable_type",    :limit => 25
      t.string   "type",              :limit => 25
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "assets", ["assetable_id", "assetable_type", "type"], :name => "ndx_type_assetable"
    add_index "assets", ["assetable_id", "assetable_type"], :name => "fk_assets"
    add_index "assets", ["user_id"], :name => "fk_user"

    create_table "ban_tracks" do |t|
      t.string   "check_sum"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "cart_tracks" do |t|
      t.integer "user_id"
      t.integer "track_id"
    end

    create_table "check_tenders" do |t|
      t.integer  "user_id"
      t.integer  "tender_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "comments" do |t|
      t.text     "comment",          :default => ""
      t.integer  "commentable_id"
      t.string   "commentable_type"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
      t.string   "email"
    end

    add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
    add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
    add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

    create_table "cost_countries" do |t|
      t.integer  "gateway_id"
      t.string   "code"
      t.string   "country"
      t.string   "currency"
      t.float    "cost"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "delayed_jobs" do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "file_links" do |t|
      t.integer  "track_id"
      t.integer  "user_id"
      t.integer  "speed"
      t.string   "file_name",    :null => false
      t.string   "file_path",    :null => false
      t.string   "file_size",    :null => false
      t.string   "content_type", :null => false
      t.string   "link",         :null => false
      t.string   "ip",           :null => false
      t.datetime "expire",       :null => false
      t.string   "state",        :null => false
    end

    create_table "gateways"  do |t|
      t.string   "type",                           :null => false
      t.string   "name"
      t.text     "description"
      t.boolean  "active",      :default => false
      t.text     "preferences"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "sms",         :default => false
    end

    create_table "last_downloads" do |t|
      t.integer  "track_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "lastsearches" do |t|
      t.string   "url_string"
      t.string   "url_attributes"
      t.string   "url_model"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "num"
      t.boolean  "delta",          :default => true, :null => false
    end

    create_table "news_items" do |t|
      t.string   "header"
      t.text     "text"
      t.string   "meta"
      t.boolean  "news",                :default => true, :null => false
      t.boolean  "delta",               :default => true, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.datetime "avatar_updated_at"
      t.text     "description"
      t.integer  "user_id"
      t.integer  "comments_count",      :default => 0
      t.string   "state"
    end

    create_table "newsimages" do |t|
      t.string   "photo_file_name"
      t.string   "photo_content_type"
      t.integer  "photo_file_size"
      t.datetime "photo_updated_at"
      t.integer  "news_item_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "orders" do |t|
      t.string   "title"
      t.string   "author"
      t.string   "floor"
      t.string   "language"
      t.string   "music"
      t.string   "state"
      t.text     "more"
      t.integer  "user_id"
      t.integer  "tender_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "pages" do |t|
      t.string   "name"
      t.string   "permalink"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "pictures" do |t|
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.datetime "avatar_updated_at"
      t.integer  "imageable_id"
      t.string   "imageable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "playlist_tracks" do |t|
      t.integer "playlist_id"
      t.integer "track_id"
      t.integer "parent_id"
      t.integer "lft"
      t.integer "rgt"
    end

    create_table "playlists" do |t|
      t.string   "title"
      t.text     "description"
      t.string   "icon_file_name"
      t.string   "icon_content_type"
      t.integer  "icon_file_size"
      t.datetime "icon_updated_at"
      t.integer  "user_id"
      t.boolean  "playlists",         :default => true, :null => false
      t.boolean  "delta",             :default => true, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "comments_count",    :default => 0
    end

    create_table "profits" do |t|
      t.string   "name"
      t.string   "code"
      t.decimal  "amount",           :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.boolean  "percentage",                                      :default => false, :null => false
      t.string   "type_transaction",                                                   :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles" do |t|
      t.string  "name",        :limit => 40
      t.text    "description"
      t.boolean "system"
      t.string  "title"
      t.text    "permissions"
    end

    create_table "roles_users", :id => false do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    create_table "satellites" do |t|
      t.string   "name"
      t.string   "ip"
      t.string   "domainname"
      t.text     "description"
      t.boolean  "master",      :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "active",      :default => false
      t.string   "community"
    end

    create_table "sms_payments" do |t|
      t.integer  "user_id"
      t.string   "status"
      t.string   "country"
      t.string   "shortcode"
      t.string   "provider"
      t.string   "prefix"
      t.float    "cost_local"
      t.float    "cost_usd"
      t.string   "phone"
      t.string   "msgid"
      t.string   "sid"
      t.string   "content"
      t.string   "sms_status"
      t.string   "code"
      t.string   "reply_message"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sms_payments", ["msgid"], :name => "index_sms_payments_on_msgid"
    add_index "sms_payments", ["status"], :name => "index_sms_payments_on_status"

    create_table "tag_clouds" do |t|
      t.string   "url_string"
      t.string   "url_attributes"
      t.string   "url_model"
      t.integer  "font_size"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "tenders" do |t|
      t.string   "link"
      t.boolean  "complete",     :default => false
      t.integer  "order_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",        :default => "unread"
      t.string   "tender_state"
    end

    add_index "tenders", ["state"], :name => "index_tenders_on_state"
    add_index "tenders", ["tender_state"], :name => "index_tenders_on_tender_state"

    create_table "tracks" do |t|
      t.string   "title"
      t.string   "author"
      t.integer  "bitrate"
      t.boolean  "tracks",            :default => true,  :null => false
      t.boolean  "delta",             :default => true,  :null => false
      t.integer  "user_id"
      t.string   "state"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "data_file_name"
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.datetime "data_updated_at"
      t.string   "data_remote_url"
      t.integer  "count_downloads",   :default => 0
      t.string   "check_sum"
      t.integer  "rating",            :default => 0
      t.integer  "satellite_id"
      t.boolean  "was_paid",          :default => false
      t.string   "length"
      t.string   "author_id"
      t.string   "fileseparator"
    end

    add_index "tracks", ["author_id"], :name => "index_tracks_on_author_id"
    add_index "tracks", ["title"], :name => "index_tracks_on_title"

    create_table "transactions" do |t|
      t.integer  "user_id",                                                           :null => false
      t.datetime "date_transaction",                                                  :null => false
      t.decimal  "amount",           :precision => 10, :scale => 2, :default => 0.0,  :null => false
      t.string   "comment"
      t.string   "kind_transaction"
      t.integer  "type_payment"
      t.integer  "type_transaction"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "gateway"
      t.string   "status"
      t.boolean  "delta",                                           :default => true, :null => false
    end

    create_table "users" do |t|
      t.string   "login"
      t.string   "email"
      t.string   "crypted_password"
      t.string   "password_salt"
      t.string   "persistence_token"
      t.string   "last_login_ip"
      t.string   "current_login_ip"
      t.string   "perishable_token",                                 :default => "",    :null => false
      t.integer  "login_count",                                      :default => 0,     :null => false
      t.datetime "last_request_at"
      t.datetime "last_login_at"
      t.datetime "current_login_at"
      t.boolean  "active",                                           :default => false
      t.boolean  "admin",                                            :default => false
      t.string   "icq"
      t.string   "webmoney_purse"
      t.decimal  "balance",           :precision => 10, :scale => 4, :default => 0.0,   :null => false
      t.decimal  "total_withdrawal",  :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.boolean  "ban",                                              :default => false
      t.datetime "start_ban"
      t.datetime "end_ban"
      t.text     "ban_reason"
      t.integer  "referrer_id"
      t.boolean  "users",                                            :default => true,  :null => false
      t.boolean  "delta",                                            :default => true,  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "type_ban"
      t.string   "ftp_password"
      t.boolean  "ftp_access",                                       :default => false, :null => false
      t.integer  "total_download",                                   :default => 0
    end

    add_index "users", ["ban"], :name => "index_users_on_ban"
    add_index "users", ["email"], :name => "index_users_on_email"
    add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
    add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
    add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"


  end

  def self.down
  end
end
