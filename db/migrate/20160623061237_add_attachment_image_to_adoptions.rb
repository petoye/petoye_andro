class AddAttachmentImageToAdoptions < ActiveRecord::Migration
  def self.up
    change_table :adoptions do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :adoptions, :image
  end
end
