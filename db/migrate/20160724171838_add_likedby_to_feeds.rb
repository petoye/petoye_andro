class AddLikedbyToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :likedby, :text, array: true, default: []
  end
end
