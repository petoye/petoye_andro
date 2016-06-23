class AddLikedbyToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :likedby, :string, array: true, default: []
  end
end
