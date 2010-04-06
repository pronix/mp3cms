class CreateSatellites < ActiveRecord::Migration
  def self.up
    create_table :satellites do |t|
      t.column :name, :string
      t.column :address, :string
      t.column :description, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :satellites
  end
end
