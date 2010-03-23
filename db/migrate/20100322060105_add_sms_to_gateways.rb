class AddSmsToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :sms, :boolean, :default => false
  end

  def self.down
    remove_column :gateways, :sms
  end
end
