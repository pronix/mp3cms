class CreateTenders < ActiveRecord::Migration
  def self.up
    create_table :tenders do |t|
      t.string  :link
      t.boolean :complete, :default => false
      t.integer :order_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tenders
  end
end

