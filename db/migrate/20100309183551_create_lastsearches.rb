class CreateLastsearches < ActiveRecord::Migration
  def self.up
    create_table :lastsearches do |t|
      t.column :search_string, :string
      t.column :site_attributes, :string
      t.column :site_section, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :lastsearches
  end
end

