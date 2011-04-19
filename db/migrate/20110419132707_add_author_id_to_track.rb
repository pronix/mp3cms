class AddAuthorIdToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :author_id, :string
    add_index :tracks, :author_id
    Track.all.each do |t|
      t.update_attribute(:author_id, Digest::MD5.hexdigest(t.author.mb_chars.downcase.to_s)[0..4])
    end
  end

  def self.down
    remove_column :tracks, :author_id
  end
end
