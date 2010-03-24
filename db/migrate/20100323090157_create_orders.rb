class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string  :title
      t.string  :author
      t.string  :voice
      t.string  :language
      t.string  :music
      t.string  :state
      t.text    :more
      t.integer :user_id
      t.integer :tender_id

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

