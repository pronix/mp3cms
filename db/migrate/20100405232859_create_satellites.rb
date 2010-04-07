class CreateSatellites < ActiveRecord::Migration
  def self.up
    create_table :satellites do |t|
      t.column :name, :string
      t.column :ip, :string
      t.column :domainname, :string
      t.column :description, :text
      t.column :master, :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :satellites
  end
end
