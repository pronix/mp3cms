class CreateLastsearches < ActiveRecord::Migration
  def self.up
    create_table :lastsearches do |t|
      t.column :request, :string
      t.column :attributes, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :lastsearches
  end
end

