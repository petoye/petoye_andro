class AddAttachmentImageToFeeds < ActiveRecord::Migration
  def self.up
    change_table :feeds do |t|
      t.attachment :image, default: nil
    end
  end

  def self.down
    remove_attachment :feeds, :image
  end
end
