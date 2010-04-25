class AddColimnInTracks < ActiveRecord::Migration
  def self.up
    add_column(:tracks, :length, :string)
  end

  def self.down
    remove_column(:tracks, :length)
  end
end
