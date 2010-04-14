class SmsPayments < ActiveRecord::Migration
  def self.up
  create_table "sms_payments", :force => true do |t|
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

  end
 def self.down
   drop_table :sms_payments
 end
end
