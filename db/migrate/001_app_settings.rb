class AppSettings < ActiveRecord::Migration
  def self.up
  create_table "app_settings" do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.string   "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["code"], :name => "index_app_settings_on_code"
  end

  def self.down
    drop_table :app_settings
  end
end
