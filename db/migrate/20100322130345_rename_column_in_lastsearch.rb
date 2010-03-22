class RenameColumnInLastsearch < ActiveRecord::Migration
  def self.up
    rename_column(:lastsearches, :search_string, :url_string)
    rename_column(:lastsearches, :site_attributes, :url_attributes)
    rename_column(:lastsearches, :site_section, :url_model)
  end

  def self.down
    rename_column(:lastsearches, :url_string, :search_string)
    rename_column(:lastsearches, :url_attributes, :site_attributes)
    rename_column(:lastsearches, :url_model, :site_section)
  end
end

