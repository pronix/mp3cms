class AddTenderStateToTenders < ActiveRecord::Migration
  def self.up
    add_column :tenders, :tender_state, :string
    add_index  :tenders, :tender_state
  end

  def self.down
    remove_column :tenders, :tender_state
    remove_index :tenders, :tender_state
  end
end
