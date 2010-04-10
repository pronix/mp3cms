class AddColumnUserTotalDownload < ActiveRecord::Migration
  def self.up
    add_column(:users, :total_download, :integer, :default => 0)
  end

  def self.down
    remove_column(:users, :total_download)
  end
end
