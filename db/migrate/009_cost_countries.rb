class CostCountries < ActiveRecord::Migration
  def self.up
  create_table "cost_countries" do |t|
    t.integer  "gateway_id"
    t.string   "code"
    t.string   "country"
    t.string   "currency"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  end
 def self.down
   drop_table :cost_countries
 end 
end


