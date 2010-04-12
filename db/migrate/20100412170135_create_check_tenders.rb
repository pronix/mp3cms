class CreateCheckTenders < ActiveRecord::Migration
  def self.up
    create_table :check_tenders do |t|
      t.column :user_id, :integer
      t.column :tender_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :check_tenders
  end
end
